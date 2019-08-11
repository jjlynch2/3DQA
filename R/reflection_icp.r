reflection_icp <- function(x,y,iterations,subsample=NULL,threads=1, break_early = NULL, k = 1) {
	y <- as.matrix(y)
	x <- as.matrix(x)
	d1 <- 999999
	d1r <- NULL
	A <- x
	for(j in 1:k) {
		if (j == 1) {x <- cbind( A[,1], A[,2],A[,3])}
		else if (j == 2) {x <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
		else if (j == 3) {x <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
		else if (j == 4) {x <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
		else if (j == 5) {x <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
		else if (j == 6) {x <- cbind( A[,1], A[,2],A[,3]*-1)}
		else if (j == 7) {x <- cbind( A[,1], A[,2]*-1,A[,3])}
		else if(j == 8) {x <- cbind( A[,1]*-1, A[,2],A[,3])}
		if(!is.null(subsample)) {
			nr1 <- nrow(y)
			nr1 <- nr1 * subsample
			nr2 <- nrow(x)
			nr2 <- nr2 * subsample
			s <- round(mean(nr1, nr2), digits = 0)
			subs <- Morpho::fastKmeans(x,k=s,iter.max = 100,threads=threads)$selected
			xtmp <- x[subs,]
		} else {
			xtmp <- x
		}
		yKD <- Rvcg::vcgCreateKDtree(y)
		for(i in 1:iterations) {
			clost <- Rvcg::vcgSearchKDtree(yKD,xtmp,1,threads=threads)
			good <- which(clost$distance < 1e15)
			trafo <- computeTransform(y[clost$index[good],],xtmp[good,],type="rigid")
			xtmp <- Morpho::applyTransform(xtmp[,],trafo)
		}
		if(!is.null(subsample)) {
			d1t <- hausdorff_dist(xtmp, y[clost$index[good],])
		} else {
			d1t <- hausdorff_dist(xtmp, y)
		}
		if(d1t[1] < d1) {
			print(paste("Registration: ", d1t[1], d1t[2], d1t[3], sep = " "))
			d1 <- d1t[1]
			d1r <- d1t
			if (!is.null(subsample)) {
				fintrafo <- Morpho::computeTransform(xtmp[,],x[subs,],type = "rigid")
				x_result <- Morpho::applyTransform(x,fintrafo)
			} else {
				x_result <- xtmp
			}
			if(!is.null(break_early)) {
				if(d1t[1] < break_early) {
					break
				}
			}
		}
	}
	if(!is.null(subsample)) {
		d1r <- hausdorff_dist(x_result, y)
	}
	return(list(x_result, d1r))
}