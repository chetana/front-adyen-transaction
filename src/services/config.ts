export const config = {
  // Backend API URL
  apiBaseUrl: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080',
  
  // Adyen environment (for display purposes only)
  adyenEnvironment: import.meta.env.VITE_ADYEN_ENVIRONMENT || 'test',
}

export const validateConfig = () => {
  const missingVars: string[] = []

  if (!config.apiBaseUrl) {
    missingVars.push('VITE_API_BASE_URL')
  }

  if (missingVars.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missingVars.join(', ')}\n` +
        'Please check your .env file and ensure all required variables are set.'
    )
  }

  return true
}