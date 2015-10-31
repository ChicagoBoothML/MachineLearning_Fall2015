plot_mnist_images <- function(mnist_matrix) {
  
  IMAGE_DIM <- 28
  
  nb_images <- nrow(mnist_matrix)
  m <- floor(sqrt(nb_images))
  n <- ceiling(nb_images / m)
  
  big_matrix <- matrix(0, nrow=m * IMAGE_DIM, ncol=n * IMAGE_DIM)
  
  for (k in 1 : m) {
    for (l in 1 : n) {
      i <- (k - 1) * n + l
      if (i <= nb_images) {
        z <- array(mnist_matrix[i, ], dim=c(IMAGE_DIM, IMAGE_DIM))
        z <- z[ , IMAGE_DIM : 1]
        big_matrix[((k - 1) * IMAGE_DIM + 1) : (k * IMAGE_DIM),
                   ((l - 1) * IMAGE_DIM + 1) : (l * IMAGE_DIM)] <- z
      }
    }
  }
  colors <- c('white', 'black')
  cus_col <- colorRampPalette(colors=colors)
  image(big_matrix, col=cus_col(256), asp=1)
}
