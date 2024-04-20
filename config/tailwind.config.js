const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Raleway', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        "primary": "#683CE4",
        "secondary": "#23C4F8",
        "accent": "#10E5B2",
      },
      animation: {
        "ticker": "ticker-animation 30s linear infinite",
      },
      keyframes: {
        "ticker-animation": {
        "0%": { transform: "translateX(90%)" },
          "100%": { transform: "translateX(-100%)" },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
