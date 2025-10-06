import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import axios from 'axios'

dotenv.config()

const app = express()
const PORT = process.env.PORT || 8080

// Middleware
app.use(cors())
app.use(express.json())

// Validate required environment variables
const requiredEnvVars = [
  'ADYEN_API_KEY',
  'ADYEN_ENVIRONMENT',
  'ADYEN_ACCOUNT_HOLDER_ID',
  'ALLOW_ORIGIN',
]

// Add ADYEN_LIVE_URL_PREFIX to required vars only if environment is live
if (process.env.ADYEN_ENVIRONMENT === 'live') {
  requiredEnvVars.push('ADYEN_LIVE_URL_PREFIX')
}

const missingEnvVars = requiredEnvVars.filter((varName) => !process.env[varName])

if (missingEnvVars.length > 0) {
  console.error(`❌ Missing required environment variables: ${missingEnvVars.join(', ')}`)
  if (process.env.ADYEN_ENVIRONMENT === 'live' && missingEnvVars.includes('ADYEN_LIVE_URL_PREFIX')) {
    console.error('ℹ️  For live environment, you need to set ADYEN_LIVE_URL_PREFIX')
    console.error('   Example: ADYEN_LIVE_URL_PREFIX=1797a841fbb37ca7-AdyenDemo')
    console.error('   Find your prefix in Adyen Customer Area > Developers > API URLs')
  }
  process.exit(1)
}

// Adyen API configuration
const ADYEN_API_BASE_URL =
  process.env.ADYEN_ENVIRONMENT === 'live'
    ? `https://${process.env.ADYEN_LIVE_URL_PREFIX}-balanceplatform-api-live.adyenpayments.com`
    : 'https://balanceplatform-api-test.adyen.com'

const ADYEN_AUTH_API_URL =
  process.env.ADYEN_ENVIRONMENT === 'live'
    ? 'https://authe-live.adyen.com/authe/api/v1/sessions'
    : 'https://test.adyen.com/authe/api/v1/sessions'

/**
 * Create an Adyen authentication session
 * POST /api/adyen/session
 */
app.post('/api/adyen/session', async (req, res) => {
  try {
    console.log('📝 Creating Adyen session...')

    const sessionRequest = {
      allowOrigin: process.env.ALLOW_ORIGIN,
      product: 'platform',
      policy: {
        resources: [
          {
            accountHolderId: process.env.ADYEN_ACCOUNT_HOLDER_ID,
            type: 'accountHolder',
          },
        ],
        roles: [
          'Transactions Overview Component: View',
          'Transactions Overview Component: Manage Refunds',
        ],
      },
    }

    const response = await axios.post(ADYEN_AUTH_API_URL, sessionRequest, {
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.ADYEN_API_KEY,
      },
    })

    console.log('✅ Adyen session created successfully')
    res.json(response.data)
  } catch (error) {
    console.error('❌ Error creating Adyen session:', error.response?.data || error.message)
    res.status(error.response?.status || 500).json({
      error: 'Failed to create Adyen session',
      details: error.response?.data || error.message,
    })
  }
})

/**
 * Refresh an Adyen authentication session
 * POST /api/adyen/session/refresh
 */
app.post('/api/adyen/session/refresh', async (req, res) => {
  try {
    console.log('🔄 Refreshing Adyen session...')

    const sessionRequest = {
      allowOrigin: process.env.ALLOW_ORIGIN,
      product: 'platform',
      policy: {
        resources: [
          {
            accountHolderId: process.env.ADYEN_ACCOUNT_HOLDER_ID,
            type: 'accountHolder',
          },
        ],
        roles: [
          'Transactions Overview Component: View',
          'Transactions Overview Component: Manage Refunds',
        ],
      },
    }

    const response = await axios.post(ADYEN_AUTH_API_URL, sessionRequest, {
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.ADYEN_API_KEY,
      },
    })

    console.log('✅ Adyen session refreshed successfully')
    res.json(response.data)
  } catch (error) {
    console.error('❌ Error refreshing Adyen session:', error.response?.data || error.message)
    res.status(error.response?.status || 500).json({
      error: 'Failed to refresh Adyen session',
      details: error.response?.data || error.message,
    })
  }
})

/**
 * Health check endpoint
 */
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    environment: process.env.ADYEN_ENVIRONMENT,
    timestamp: new Date().toISOString(),
    config: {
      balancePlatformApiUrl: ADYEN_API_BASE_URL,
      authApiUrl: ADYEN_AUTH_API_URL,
      hasLivePrefix: process.env.ADYEN_ENVIRONMENT === 'live' ? !!process.env.ADYEN_LIVE_URL_PREFIX : 'N/A',
    },
  })
})

app.listen(PORT, () => {
  console.log(`🚀 Adyen Transaction Server running on port ${PORT}`)
  console.log(`📍 Environment: ${process.env.ADYEN_ENVIRONMENT}`)
  console.log(`🔗 Health check: http://localhost:${PORT}/health`)
  console.log(`🌐 Balance Platform API: ${ADYEN_API_BASE_URL}`)
  console.log(`🔐 Auth API: ${ADYEN_AUTH_API_URL}`)
  if (process.env.ADYEN_ENVIRONMENT === 'live') {
    console.log(`🏷️  Live URL Prefix: ${process.env.ADYEN_LIVE_URL_PREFIX ? '✅ Configured' : '❌ Missing'}`)
  }
})