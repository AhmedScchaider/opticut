opticut.formula <-
function(formula, data, strata, dist="gaussian",
comb=c("rank", "all"), sset=NULL, cl=NULL, ...)
{
    if (missing(data))
        data <- parent.frame()
    Strata <- deparse(substitute(strata))
    if (Strata %in% names(data))
        strata <- data[[Strata]]
    mf <- match.call(expand.dots = FALSE)
    mm <- match(c("formula", "data"), names(mf), 0)
    mf <- mf[c(1, mm)]
    mf$drop.unused.levels <- TRUE
    mf[[1]] <- as.name("model.frame")
    mf <- eval(mf, parent.frame())
    Y <- model.response(mf, "numeric")
    Y <- data.matrix(Y)
    ff <- formula
    ff[[2]] <- NULL
    mt <- terms(ff, data = data)
    X <- model.matrix(mt, mf)

    if (any(is.na(Y)))
        stop("lhs of formula contains NA")
    if (any(is.na(X)))
        stop("rhs of formula contains NA")
    if (any(is.na(strata)))
        stop("strata argument contains NA")

    out <- opticut.default(Y=Y, X=X, strata=strata, dist=dist,
        comb=comb, sset=sset, cl=cl, ...)
    out$call <- match.call()
    if (is.function(dist)) {
        attr(out$dist, "dist") <- deparse(substitute(dist))
        for (i in seq_len(length(out$species)))
            attr(out$species[[i]], "dist") <- deparse(substitute(dist))
    }
    out
}
