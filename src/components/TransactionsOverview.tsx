import { useEffect, useRef, useState } from 'react'
import {
  AdyenPlatformExperience,
  TransactionsOverview as AdyenTransactionsOverview,
} from '@adyen/adyen-platform-experience-web'
import '@adyen/adyen-platform-experience-web/adyen-platform-experience-web.css'
import { createAdyenSession } from '@/services/api'
import { config } from '@/services/config'
import type { TransactionsOverviewConfig } from '@/types/adyen'

interface TransactionsOverviewProps {
  allowLimitSelection?: boolean
  preferredLimit?: number
  onRecordSelection?: (record: { id: string }) => void
}

export const TransactionsOverview = ({
  allowLimitSelection = true,
  preferredLimit = 10,
  onRecordSelection,
}: TransactionsOverviewProps) => {
  const containerRef = useRef<HTMLDivElement>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const componentRef = useRef<any>(null)
  const adyenComponentRef = useRef<any>(null)

  // Initialize Adyen component
  useEffect(() => {
    let mounted = true

    const initializeComponent = async () => {
      try {
        console.log('🔄 Starting Adyen component initialization...')
        setIsLoading(true)
        setError(null)

        // Function to handle session creation
        const handleSessionCreate = async () => {
          console.log('📝 Creating Adyen session...')
          const response = await createAdyenSession()
          console.log('✅ Session created:', response)
          return response
        }

        // Initialize the Adyen Platform Experience library
        console.log('🚀 Initializing Adyen Platform Experience...')
        console.log('🌍 Environment:', config.adyenEnvironment)
        const core = await AdyenPlatformExperience({
          environment: config.adyenEnvironment as 'test' | 'live',
          onSessionCreate: handleSessionCreate,
        })
        console.log('✅ Core initialized:', core)

        if (!mounted) {
          console.log('⚠️ Component unmounted, aborting...')
          return
        }

        // Create the Transactions Overview component
        const componentConfig: TransactionsOverviewConfig = {
          core,
          allowLimitSelection,
          preferredLimit,
        }

        if (onRecordSelection) {
          componentConfig.onRecordSelection = onRecordSelection
        }

        console.log('📦 Creating TransactionsOverview with config:', componentConfig)
        const transactionsOverview = new AdyenTransactionsOverview(componentConfig)
        console.log('✅ TransactionsOverview created:', transactionsOverview)

        if (!mounted) {
          console.log('⚠️ Component unmounted after creation, aborting...')
          return
        }

        // Store the component and signal that we're ready to mount
        adyenComponentRef.current = transactionsOverview
        setIsLoading(false)
      } catch (err) {
        console.error('❌ Error initializing Transactions Overview:', err)
        if (mounted) {
          setError(
            err instanceof Error ? err.message : 'Failed to initialize Transactions Overview'
          )
          setIsLoading(false)
        }
      }
    }

    initializeComponent()

    return () => {
      mounted = false
      console.log('🧹 Cleaning up component...')
      // Cleanup: unmount the component if it exists
      if (componentRef.current && componentRef.current.unmount) {
        componentRef.current.unmount()
        console.log('✅ Component unmounted')
      }
      adyenComponentRef.current = null
    }
  }, [allowLimitSelection, preferredLimit, onRecordSelection])

  // Mount the component when container is ready
  useEffect(() => {
    if (!isLoading && adyenComponentRef.current && containerRef.current && !componentRef.current) {
      console.log('🎯 Mounting component to container:', containerRef.current)
      try {
        adyenComponentRef.current.mount(containerRef.current)
        componentRef.current = adyenComponentRef.current
        console.log('✅ Component mounted successfully!')
      } catch (err) {
        console.error('❌ Error mounting component:', err)
        setError('Failed to mount component')
      }
    }
  }, [isLoading])

  if (error) {
    return (
      <div className="error-container" style={{ padding: '20px', color: 'red' }}>
        <h3>Error</h3>
        <p>{error}</p>
      </div>
    )
  }

  if (isLoading) {
    return (
      <div className="loading-container" style={{ padding: '20px', textAlign: 'center' }}>
        <p>Loading transactions...</p>
      </div>
    )
  }

  return <div ref={containerRef} id="transactions-overview-container" />
}