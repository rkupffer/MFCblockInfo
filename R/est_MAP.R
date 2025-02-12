est.MAP <- function(FUN, responses, int, loads, uni, perms, which.blocks=NULL, SE=TRUE, ...) {

  nb <- nrow(perms)
  K <- nrow(loads)/nb
  bi <- create.block.ind(K,nb)
  bi_int <- create.blocks.int(K,nb)
  perms_int <- create.perms.int(nb, perms=perms)
  perms_order <- apply(perms, 2, order)
  Tr <- create.tr(nb)

  traits <- ses <- matrix(NA, nrow(responses), ncol(loads))

  #loop over persons
  for(j in 1:nrow(responses)) {

    result <- optim(par=rep(0,ncol(loads)),method="L-BFGS-B", fn=lh, lhb.fun=FUN, hessian=SE,
                 control = list(fnscale=-1), lower=rep(-3,ncol(loads)),upper=rep(3,ncol(loads)),
                 responsesj=responses[j,], loads=loads, int=int, uni=uni, bi=bi, bi_int=bi_int,
                 perms_int=perms_int, Tr=Tr, perms=perms_order, ...)
    traits[j,] <- result$par
    if(isTRUE(SE)) ses[j,] <- sqrt(diag(MASS::ginv(-result$hessian)))
   }
  return(list("traits"=traits, "ses"=ses))
}
