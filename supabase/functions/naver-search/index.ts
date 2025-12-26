import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { query } = await req.json()
    
    const clientId = Deno.env.get('NAVER_CLIENT_ID')
    const clientSecret = Deno.env.get('NAVER_CLIENT_SECRET')

    const response = await fetch(
      `https://openapi.naver.com/v1/search/book.json?query=${encodeURIComponent(query)}&display=20`,
      {
        headers: {
          'X-Naver-Client-Id': clientId!,
          'X-Naver-Client-Secret': clientSecret!,
        },
      }
    )

    const data = await response.json()

    return new Response(JSON.stringify(data), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})