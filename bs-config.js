module.exports = {
  server: {
    baseDir: "./",
    middleware: function (req, res, next) {
      res.setHeader(
        "Content-Security-Policy",
        "default-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
      );
      next();
    },
  },
};
