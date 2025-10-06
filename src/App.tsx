import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { TransactionsPage } from '@/pages/TransactionsPage'
import { validateConfig } from '@/services/config'

function App() {
  try {
    validateConfig()
  } catch (error) {
    return (
      <div
        style={{
          padding: '40px',
          maxWidth: '800px',
          margin: '0 auto',
          fontFamily: 'system-ui, -apple-system, sans-serif',
        }}
      >
        <div
          style={{
            backgroundColor: '#fee',
            border: '1px solid #fcc',
            borderRadius: '8px',
            padding: '20px',
          }}
        >
          <h1 style={{ color: '#c00', marginTop: 0 }}>Configuration Error</h1>
          <p style={{ color: '#600' }}>
            {error instanceof Error ? error.message : 'Unknown configuration error'}
          </p>
          <details style={{ marginTop: '20px' }}>
            <summary style={{ cursor: 'pointer', fontWeight: 'bold' }}>
              How to fix this issue
            </summary>
            <ol style={{ marginTop: '10px', lineHeight: '1.6' }}>
              <li>Copy the <code>.env.example</code> file to <code>.env</code></li>
              <li>Fill in all required environment variables with your Adyen credentials</li>
              <li>Restart the development server</li>
            </ol>
          </details>
        </div>
      </div>
    )
  }

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Navigate to="/transactions" replace />} />
        <Route path="/transactions" element={<TransactionsPage />} />
      </Routes>
    </Router>
  )
}

export default App