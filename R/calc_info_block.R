#' MFC block information
#'
#' across persons and items
#'
#' @param FUN function to compute response probability
#' @param traits matrix of traits, rows = persons, columns = traits
#' @param int vector of item intercepts
#' @param loads matrix of item loadings, rows = items, columns = traits
#' @param uni matrix of item uniquenesses
#' @param K numeric, number of blocks
#' @param nb numeric, block size
#' @param which.blocks vector, optional, indices of blocks to calculate info for, defaults to 1:K
#' @param ... other arguments passed to FUN
#'
#' @return list of length N, with entries (block,trait,trait)
#' @export
#'
#' @examples
calc.info.block <- function(FUN, traits=NULL, int, loads, uni, K, nb, which.blocks=NULL, ...) {
  if (is.vector(traits)) traits <- t(matrix(traits))
  if(is.null(which.blocks)) which.blocks <- 1:K

  perms <- permute(1:nb)
  perms_int <- create.perms.int(nb, perms)
  Tr <- create.tr(nb)
  bi <- create.block.ind(K,nb)
  bi_int <- create.blocks.int(K,nb)

  #select only items in which.blocks
  if(isFALSE(setequal(which.blocks, 1:K))) {
    bi <- matrix(bi[which.blocks,], length(which.blocks), nb)
    bi_int <- matrix(bi_int[,which.blocks], nb, length(which.blocks))
    K <- nrow(bi)
  }

  #info for whole block (internal), summed over permutations/patterns
  .calc.info.block <- function(FUN, traits, int, loads, uni, perms, perms_int, Tr, ...) {
    ib <- lapply(1:ncol(perms), function(perm, traits, int, loads, uni, perms, perms_int, Tr)
      calc.pattern.info(FUN=FUN, traits=traits, int=int, loads=loads, uni=uni, y_b=perm, perms=perms, perms_int=perms_int, Tr=Tr, ...),
      traits=traits, int=int, loads=loads, uni=uni, perms=perms, perms_int=perms_int, Tr=Tr)
    ib <- abind::abind(ib, along=3)
    rowSums(ib, dims=2)
  }

  all.infos <- vector("list", nrow(traits))
  for (n in 1:length(all.infos)) all.infos[[n]] <- array(dim=c(K,ncol(loads),ncol(loads)))

  for (k in 1:K) {
    b <- bi[k,]
    b_int <- bi_int[,k]

    for (n in 1:nrow(traits)) {
      all.infos[[n]][k,,] <- .calc.info.block(FUN, traits[n,], c(int[b_int],-int[b_int]), loads[b,], uni[b,b], perms, nb=nb, perms_int=perms_int, Tr=Tr, ...)
    }
  }
  return(all.infos)
}
