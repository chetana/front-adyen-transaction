import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { TransactionDetails } from '@/components/TransactionDetails'

export const TransactionsPage = () => {
  const [selectedTransactionId, setSelectedTransactionId] = useState<string | null>(null)

  const handleRecordSelection = (record: { id: string }) => {
    setSelectedTransactionId(record.id)
  }

  const handleCloseDetails = () => {
    setSelectedTransactionId(null)
  }

  return (
    <div className="transactions-page" style={{ padding: '20px' }}>
      <header style={{ marginBottom: '20px' }}>
        <h1>Adyen Transactions</h1>
        <p>View and manage your platform transactions</p>
      </header>

      {selectedTransactionId ? (
        <TransactionDetails transactionId={selectedTransactionId} onClose={handleCloseDetails} />
      ) : (
        <TransactionsOverview
          allowLimitSelection={true}
          preferredLimit={10}
          onRecordSelection={handleRecordSelection}
        />
      )}
    </div>
  )
}