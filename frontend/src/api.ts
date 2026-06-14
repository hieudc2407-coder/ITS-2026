/**
 * API Service Module
 * Handles all API communication with the backend
 */

const API_BASE_URL = 'http://localhost:8000/api';

export interface Violation {
  id: string;
  plate_number: string;
  location: string;
  timestamp: string;
  severity: 'low' | 'medium' | 'high';
  status: 'pending' | 'alerted' | 'resolved';
  image_url?: string;
  details?: string;
}

export interface AlertRequest {
  violation_id: string;
  message?: string;
}

export interface AlertResponse {
  success: boolean;
  message: string;
  violation_id: string;
}

export interface ApiError {
  error: string;
  details?: string;
  status: number;
}

/**
 * Fetch violations from the backend
 */
export async function getViolations(): Promise<Violation[]> {
  try {
    const response = await fetch(`${API_BASE_URL}/violations`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({
        error: `HTTP ${response.status}`,
      }));
      throw {
        error: error.error || 'Failed to fetch violations',
        status: response.status,
      } as ApiError;
    }

    const data = await response.json();
    // Handle both array and object responses
    return Array.isArray(data) ? data : data.violations || [];
  } catch (error) {
    console.error('Error fetching violations:', error);
    throw error;
  }
}

/**
 * Send alert for a specific violation (trigger Telegram notification)
 */
export async function sendAlert(
  violationId: string,
  customMessage?: string
): Promise<AlertResponse> {
  try {
    const payload: AlertRequest = {
      violation_id: violationId,
    };

    if (customMessage) {
      payload.message = customMessage;
    }

    const response = await fetch(`${API_BASE_URL}/alert`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({
        error: `HTTP ${response.status}`,
      }));
      throw {
        error: error.error || 'Failed to send alert',
        status: response.status,
      } as ApiError;
    }

    const data = await response.json();
    return {
      success: data.success || true,
      message: data.message || 'Alert sent successfully',
      violation_id: violationId,
    };
  } catch (error) {
    console.error('Error sending alert:', error);
    throw error;
  }
}

/**
 * Health check to verify backend connectivity
 */
export async function healthCheck(): Promise<boolean> {
  try {
    const response = await fetch(`${API_BASE_URL}/health`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    return response.ok;
  } catch (error) {
    console.error('Health check failed:', error);
    return false;
  }
}

/**
 * Format timestamp to readable date string
 */
export function formatTimestamp(timestamp: string): string {
  try {
    const date = new Date(timestamp);
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: true,
    });
  } catch {
    return timestamp;
  }
}
