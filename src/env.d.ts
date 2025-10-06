/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_ADYEN_API_KEY: string
  readonly VITE_ADYEN_ENVIRONMENT: 'test' | 'live'
  readonly VITE_ADYEN_ACCOUNT_HOLDER_ID: string
  readonly VITE_ALLOW_ORIGIN: string
  readonly VITE_API_BASE_URL: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

declare const APP_VERSION: string
declare const APP_ENVIRONMENT: string