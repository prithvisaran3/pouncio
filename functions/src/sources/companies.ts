export interface CompanyConfig {
  name: string;
  slug: string;
  source: 'greenhouse' | 'lever' | 'ashby';
}

export const TARGET_COMPANIES: CompanyConfig[] = [
  // Greenhouse
  { name: 'Figma', slug: 'figma', source: 'greenhouse' },
  { name: 'Stripe', slug: 'stripe', source: 'greenhouse' },
  { name: 'Pinterest', slug: 'pinterest', source: 'greenhouse' },
  { name: 'HubSpot', slug: 'hubspot', source: 'greenhouse' },
  
  // Lever
  { name: 'Vercel', slug: 'vercel', source: 'lever' },
  { name: 'Palantir', slug: 'palantir', source: 'lever' },
  { name: 'Replicate', slug: 'replicate', source: 'lever' },
  { name: 'Sentry', slug: 'sentry', source: 'lever' },

  // Ashby
  { name: 'OpenAI', slug: 'openai', source: 'ashby' },
  { name: 'Anthropic', slug: 'anthropic', source: 'ashby' },
  { name: 'Vanta', slug: 'vanta', source: 'ashby' }
];
