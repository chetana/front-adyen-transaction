# Exemples d'Utilisation - Adyen Transaction

## Table des Matières

1. [Utilisation de Base](#utilisation-de-base)
2. [Personnalisation des Composants](#personnalisation-des-composants)
3. [Gestion des Événements](#gestion-des-événements)
4. [Intégration avec d'Autres Systèmes](#intégration-avec-dautres-systèmes)
5. [Cas d'Usage Avancés](#cas-dusage-avancés)

## Utilisation de Base

### Afficher la Liste des Transactions

```tsx
import { TransactionsOverview } from '@/components/TransactionsOverview'

function MyPage() {
  return (
    <div>
      <h1>Mes Transactions</h1>
      <TransactionsOverview />
    </div>
  )
}
```

### Afficher les Détails d'une Transaction

```tsx
import { TransactionDetails } from '@/components/TransactionDetails'

function TransactionPage() {
  const transactionId = 'TX123456789'
  
  return (
    <div>
      <h1>Détails de la Transaction</h1>
      <TransactionDetails transactionId={transactionId} />
    </div>
  )
}
```

## Personnalisation des Composants

### Modifier le Nombre de Transactions par Page

```tsx
<TransactionsOverview
  preferredLimit={25}  // Affiche 25 transactions par page
  allowLimitSelection={true}  // Permet à l'utilisateur de changer
/>
```

### Désactiver la Sélection du Nombre de Lignes

```tsx
<TransactionsOverview
  preferredLimit={10}
  allowLimitSelection={false}  // L'utilisateur ne peut pas changer
/>
```

## Gestion des Événements

### Capturer la Sélection d'une Transaction

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { TransactionDetails } from '@/components/TransactionDetails'

function TransactionsPage() {
  const [selectedId, setSelectedId] = useState<string | null>(null)

  const handleSelection = (record: { id: string }) => {
    console.log('Transaction sélectionnée:', record.id)
    setSelectedId(record.id)
  }

  return (
    <div>
      {selectedId ? (
        <TransactionDetails
          transactionId={selectedId}
          onClose={() => setSelectedId(null)}
        />
      ) : (
        <TransactionsOverview onRecordSelection={handleSelection} />
      )}
    </div>
  )
}
```

### Afficher les Détails dans un Modal

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { TransactionDetails } from '@/components/TransactionDetails'
import Modal from 'react-modal'

function TransactionsWithModal() {
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [isModalOpen, setIsModalOpen] = useState(false)

  const handleSelection = (record: { id: string }) => {
    setSelectedId(record.id)
    setIsModalOpen(true)
  }

  const closeModal = () => {
    setIsModalOpen(false)
    setSelectedId(null)
  }

  return (
    <div>
      <TransactionsOverview onRecordSelection={handleSelection} />
      
      <Modal
        isOpen={isModalOpen}
        onRequestClose={closeModal}
        contentLabel="Détails de la Transaction"
      >
        {selectedId && (
          <TransactionDetails
            transactionId={selectedId}
            onClose={closeModal}
          />
        )}
      </Modal>
    </div>
  )
}
```

## Intégration avec d'Autres Systèmes

### Synchroniser avec une Base de Données Locale

```tsx
import { useState, useEffect } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { saveTransactionToDb } from '@/services/database'

function SyncedTransactions() {
  const handleSelection = async (record: { id: string }) => {
    try {
      // Sauvegarder dans la base de données locale
      await saveTransactionToDb(record.id)
      console.log('Transaction sauvegardée:', record.id)
    } catch (error) {
      console.error('Erreur de sauvegarde:', error)
    }
  }

  return (
    <TransactionsOverview onRecordSelection={handleSelection} />
  )
}
```

### Envoyer des Notifications

```tsx
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { sendNotification } from '@/services/notifications'

function TransactionsWithNotifications() {
  const handleSelection = (record: { id: string }) => {
    sendNotification({
      title: 'Transaction Sélectionnée',
      message: `Vous consultez la transaction ${record.id}`,
      type: 'info'
    })
  }

  return (
    <TransactionsOverview onRecordSelection={handleSelection} />
  )
}
```

### Intégration avec Analytics

```tsx
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { trackEvent } from '@/services/analytics'

function TrackedTransactions() {
  const handleSelection = (record: { id: string }) => {
    // Envoyer un événement à Google Analytics, Mixpanel, etc.
    trackEvent('transaction_viewed', {
      transaction_id: record.id,
      timestamp: new Date().toISOString()
    })
  }

  return (
    <TransactionsOverview onRecordSelection={handleSelection} />
  )
}
```

## Cas d'Usage Avancés

### Filtrage par Compte

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'

function FilteredTransactions() {
  const [accountId, setAccountId] = useState('AH00000000000000000000001')

  return (
    <div>
      <select
        value={accountId}
        onChange={(e) => setAccountId(e.target.value)}
      >
        <option value="AH00000000000000000000001">Compte 1</option>
        <option value="AH00000000000000000000002">Compte 2</option>
      </select>

      {/* Note: Vous devrez recréer le composant avec le nouvel accountId */}
      <TransactionsOverview key={accountId} />
    </div>
  )
}
```

### Affichage Conditionnel selon les Permissions

```tsx
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { usePermissions } from '@/hooks/usePermissions'

function PermissionBasedTransactions() {
  const { canViewTransactions, canManageRefunds } = usePermissions()

  if (!canViewTransactions) {
    return <div>Vous n'avez pas la permission de voir les transactions.</div>
  }

  return (
    <div>
      <TransactionsOverview />
      {canManageRefunds && (
        <p>Vous pouvez également gérer les remboursements.</p>
      )}
    </div>
  )
}
```

### Multi-Comptes avec Onglets

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'

interface Account {
  id: string
  name: string
  holderId: string
}

function MultiAccountTransactions() {
  const [activeTab, setActiveTab] = useState(0)
  
  const accounts: Account[] = [
    { id: '1', name: 'Compte Principal', holderId: 'AH00000000000000000000001' },
    { id: '2', name: 'Compte Secondaire', holderId: 'AH00000000000000000000002' },
    { id: '3', name: 'Compte Test', holderId: 'AH00000000000000000000003' },
  ]

  return (
    <div>
      <div className="tabs">
        {accounts.map((account, index) => (
          <button
            key={account.id}
            onClick={() => setActiveTab(index)}
            className={activeTab === index ? 'active' : ''}
          >
            {account.name}
          </button>
        ))}
      </div>

      <div className="tab-content">
        {/* Utiliser key pour forcer le remontage du composant */}
        <TransactionsOverview key={accounts[activeTab].holderId} />
      </div>
    </div>
  )
}
```

### Export de Données

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { exportTransactions } from '@/services/export'

function ExportableTransactions() {
  const [isExporting, setIsExporting] = useState(false)

  const handleExport = async () => {
    setIsExporting(true)
    try {
      await exportTransactions()
      alert('Export réussi !')
    } catch (error) {
      alert('Erreur lors de l\'export')
    } finally {
      setIsExporting(false)
    }
  }

  return (
    <div>
      <div className="toolbar">
        <button onClick={handleExport} disabled={isExporting}>
          {isExporting ? 'Export en cours...' : 'Exporter les transactions'}
        </button>
      </div>
      
      <TransactionsOverview />
    </div>
  )
}
```

### Rafraîchissement Automatique

```tsx
import { useState, useEffect } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'

function AutoRefreshTransactions() {
  const [refreshKey, setRefreshKey] = useState(0)

  useEffect(() => {
    // Rafraîchir toutes les 30 secondes
    const interval = setInterval(() => {
      setRefreshKey(prev => prev + 1)
    }, 30000)

    return () => clearInterval(interval)
  }, [])

  return (
    <div>
      <div className="header">
        <h1>Transactions (Auto-refresh)</h1>
        <button onClick={() => setRefreshKey(prev => prev + 1)}>
          Rafraîchir maintenant
        </button>
      </div>
      
      {/* Le key force le remontage du composant */}
      <TransactionsOverview key={refreshKey} />
    </div>
  )
}
```

### Gestion des Erreurs Personnalisée

```tsx
import { useState } from 'react'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { ErrorBoundary } from 'react-error-boundary'

function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert" className="error-container">
      <h2>Une erreur est survenue</h2>
      <pre>{error.message}</pre>
      <button onClick={resetErrorBoundary}>Réessayer</button>
    </div>
  )
}

function RobustTransactions() {
  return (
    <ErrorBoundary
      FallbackComponent={ErrorFallback}
      onReset={() => window.location.reload()}
    >
      <TransactionsOverview />
    </ErrorBoundary>
  )
}
```

### Intégration avec Redux

```tsx
import { useDispatch } from 'react-redux'
import { TransactionsOverview } from '@/components/TransactionsOverview'
import { setSelectedTransaction } from '@/store/transactionsSlice'

function ReduxTransactions() {
  const dispatch = useDispatch()

  const handleSelection = (record: { id: string }) => {
    dispatch(setSelectedTransaction(record.id))
  }

  return (
    <TransactionsOverview onRecordSelection={handleSelection} />
  )
}
```

### Personnalisation des Données Affichées

```tsx
import { TransactionsOverview } from '@/components/TransactionsOverview'

function CustomizedTransactions() {
  const dataCustomization = {
    list: {
      // Personnalisation de la liste
      columns: ['date', 'amount', 'status', 'reference'],
    },
    details: {
      // Personnalisation des détails
      sections: ['overview', 'payment', 'metadata'],
    }
  }

  return (
    <TransactionsOverview dataCustomization={dataCustomization} />
  )
}
```

## Bonnes Pratiques

### 1. Gestion de l'État

```tsx
// ✅ Bon : Utiliser un state management approprié
import { create } from 'zustand'

interface TransactionStore {
  selectedId: string | null
  setSelectedId: (id: string | null) => void
}

const useTransactionStore = create<TransactionStore>((set) => ({
  selectedId: null,
  setSelectedId: (id) => set({ selectedId: id }),
}))

function MyComponent() {
  const { selectedId, setSelectedId } = useTransactionStore()
  // ...
}
```

### 2. Mémorisation

```tsx
// ✅ Bon : Mémoriser les callbacks
import { useCallback } from 'react'

function OptimizedTransactions() {
  const handleSelection = useCallback((record: { id: string }) => {
    console.log('Selected:', record.id)
  }, [])

  return <TransactionsOverview onRecordSelection={handleSelection} />
}
```

### 3. Gestion des Erreurs

```tsx
// ✅ Bon : Toujours gérer les erreurs
function SafeTransactions() {
  const handleSelection = (record: { id: string }) => {
    try {
      // Votre logique
    } catch (error) {
      console.error('Error:', error)
      // Afficher un message à l'utilisateur
    }
  }

  return <TransactionsOverview onRecordSelection={handleSelection} />
}
```

## Support

Pour plus d'exemples et de documentation, consultez :
- [README.md](README.md)
- [TECHNICAL.md](TECHNICAL.md)
- [Documentation Adyen](https://docs.adyen.com/)