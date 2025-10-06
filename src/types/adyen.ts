export interface AdyenSessionRequest {
  allowOrigin: string
  product: 'platform'
  policy: {
    resources: Array<{
      accountHolderId: string
      type: 'accountHolder'
    }>
    roles: string[]
  }
}

export interface AdyenSessionResponse {
  id: string
  token: string
}

export interface TransactionDetailsConfig {
  core: any
  id: string
}

export interface TransactionsOverviewConfig {
  core: any
  allowLimitSelection?: boolean
  preferredLimit?: number
  onRecordSelection?: (record: { id: string }) => void
  dataCustomization?: {
    list?: any
    details?: any
  }
}