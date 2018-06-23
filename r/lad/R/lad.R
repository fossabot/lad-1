lad <- function(X, y, yerr = NA, l1_regularizer = 0., maxiter = 50,
                rtol = 1e-4, eps = 1e-6) {
  X <- as.matrix(X)
  y <- as.array(y)

  if (is.na(yerr)) {
    yerr <- 1.
  } else {
    yerr <- as.vector(yerr) / sqrt(2.)
  }

  X <- X / yerr
  y <- y / yerr

  p <- ncol(X)
  beta <- solve(t(X) %*% X + diag(l1_regularizer, p)) %*% t(X) %*% y
  k <- 1
  while (k <= maxiter) {
    reg_factor <- norm(beta, '1')
    l1_factor <- as.vector(eps + sqrt(abs(y - X %*% beta)))

    X <- X / l1_factor
    y <- y / l1_factor

    beta_k <- solve(t(X) %*% X + diag(l1_regularizer / reg_factor, p)) %*% t(X) %*% y
    rel_err <- norm(beta - beta_k, '1') / max(1., reg_factor)

    if (rel_err < rtol)
      break

    beta <- beta_k
    k <- k + 1
  }
  return(beta)
}