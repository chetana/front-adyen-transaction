import axios from 'axios'
import type { AdyenSessionRequest, AdyenSessionResponse } from '@/types/adyen'

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080',
  headers: {
    'Content-Type': 'application/json',
  },
})

/**
 * Create an Adyen authentication session
 * This should be called from your backend server
 */
export const createAdyenSession = async (): Promise<AdyenSessionResponse> => {
  try {
    const response = await apiClient.post<AdyenSessionResponse>('/api/adyen/session')
    return response.data
  } catch (error) {
    console.error('Error creating Adyen session:', error)
    throw error
  }
}

/**
 * Refresh an existing Adyen session
 */
export const refreshAdyenSession = async (): Promise<AdyenSessionResponse> => {
  try {
    const response = await apiClient.post<AdyenSessionResponse>('/api/adyen/session/refresh')
    return response.data
  } catch (error) {
    console.error('Error refreshing Adyen session:', error)
    throw error
  }
}

export default apiClient