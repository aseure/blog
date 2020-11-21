module.exports = {
  purge: {
    content: [
      "./layouts/**/*.html",
      "./public/**/*.html",
    ],
  },
  theme: {
    extend: {
      colors: {
        'solarize-beige': '#fdf6e3',
        'solarize-blue': '#268bd2',
      }
    }
  },
  variants: {},
  plugins: [],
}
