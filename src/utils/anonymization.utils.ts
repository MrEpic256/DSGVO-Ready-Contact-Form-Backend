/**
 * DSGVO Anonymization Utilities
 * Functions to ensure data privacy compliance
 */

/**
 * Anonymizes an IPv4 address by removing the last octet
 * Example: 192.168.1.123 -> 192.168.1.0
 * 
 * @param ipAddress - The IP address to anonymize
 * @returns Anonymized IP address
 */
export function anonymizeIPv4(ipAddress: string): string {
  if (!ipAddress) {
    return '0.0.0.0';
  }

  // Handle IPv6 mapped IPv4 addresses (::ffff:192.168.1.1)
  const ipv4Pattern = /(?:::ffff:)?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i;
  const match = ipAddress.match(ipv4Pattern);
  
  if (match) {
    const cleanIP = match[1];
    const octets = cleanIP.split('.');
    
    if (octets.length === 4) {
      // Replace last octet with 0
      octets[3] = '0';
      return octets.join('.');
    }
  }

  // For IPv6 or unrecognized formats, return anonymized placeholder
  if (ipAddress.includes(':')) {
    // Simple IPv6 anonymization - remove last segment
    const segments = ipAddress.split(':');
    if (segments.length > 1) {
      segments[segments.length - 1] = '0';
      return segments.join(':');
    }
  }

  return '0.0.0.0';
}

/**
 * Sanitizes user agent string to limit storage size
 * @param userAgent - Raw user agent string
 * @returns Sanitized user agent (max 500 chars)
 */
export function sanitizeUserAgent(userAgent: string | undefined): string {
  if (!userAgent) {
    return 'Unknown';
  }
  
  // Limit length to prevent database issues
  return userAgent.substring(0, 500);
}
