import { useEffect, useRef, useState } from 'react'
import {
  AdyenPlatformExperience,
  TransactionDetails as AdyenTransactionDetails,
} from '@adyen/adyen-platform-experience-web'
import '@adyen/adyen-platform-experience-web/adyen-platform-experience-web.css'
import { createAdyenSession } from '@/services/api'
import type { TransactionDetailsConfig } from '@/types/adyen'

interface TransactionDetailsProps {
  transactionId: string
  onClose?: () => void
}

export const TransactionDetails = ({ transactionId, onClose }: TransactionDetailsProps) => {
  const containerRef = useRef<HTMLDivElement>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const componentRef = useRef<any>(null)

  useEffect(() => {
    let mounted = true

    const initializeComponent = async () => {
      try {
        setIsLoading(true)
        setError(null)

        // Function to handle session creation
        const handleSessionCreate = async () => {
          const response = await createAdyenSession()
          return response
        }

        // Initialize the Adyen Platform Experience library
        const core = await AdyenPlatformExperience({
          onSessionCreate: handleSessionCreate,
        })

        if (!mounted) return

        // Create the Transaction Details component
        const config: TransactionDetailsConfig = {
          core,
          id: transactionId,
        }

        const transactionDetails = new AdyenTransactionDetails(config)

        // Mount the component
        if (containerRef.current) {
          transactionDetails.mount(containerRef.current)
          componentRef.current = transactionDetails
        }

        setIsLoading(false)
      } catch (err) {
        console.error('Error initializing Transaction Details:', err)
        if (mounted) {
          setError(
            err instanceof Error ? err.message : 'Failed to initialize Transaction Details'
          )
          setIsLoading(false)
        }
      }
    }

    if (transactionId) {
      initializeComponent()
    }

    return () => {
      mounted = false
      // Cleanup: unmount the component if it exists
      if (componentRef.current && componentRef.current.unmount) {
        componentRef.current.unmount()
      }
    }
  }, [transactionId])

  if (error) {
    return (
      <div className="error-container" style={{ padding: '20px', color: 'red' }}>
        <h3>Error</h3>
        <p>{error}</p>
        {onClose && (
          <button onClick={onClose} style={{ marginTop: '10px' }}>
            Close
          </button>
        )}
      </div>
    )
  }

  if (isLoading) {
    return (
      <div className="loading-container" style={{ padding: '20px', textAlign: 'center' }}>
        <p>Loading transaction details...</p>
      </div>
    )
  }

  return (
    <div>
      {onClose && (
        <button
          onClick={onClose}
          style={{
            marginBottom: '10px',
            padding: '8px 16px',
            cursor: 'pointer',
          }}
        >
          ← Back to Overview
        </button>
      )}
      <div ref={containerRef} id="transaction-details-container" />
    </div>
  )
}