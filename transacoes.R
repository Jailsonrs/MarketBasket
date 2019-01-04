transa<- function (f, format = c("basket", "single"), sep = "", cols = NULL,
    rm.duplicates = FALSE, quote = "\"'", skip = 0, encoding = "unknown")
{
    format <- match.arg(format)
    if (format == "basket") {
        data <- f
        if (skip > 0)
            data <- data[-(1:skip)]
        if (!is.null(cols)) {
            if (!(is(cols, "numeric") && (length(cols) == 1)))
                stop("'cols' must be a numeric scalar for 'basket'.")
            cols <- as(cols, "integer")
            names(data) <- sapply(data, "[", cols)
            data <- lapply(data, "[", -cols)
        }
        data <- lapply(data, function(x) gsub("^\\s*|\\s*$",
            "", x))
        data <- lapply(data, function(x) x[nchar(x) > 0])
        if (rm.duplicates)
            data <- .rm.duplicates(data)
        return(as(data, "transactions"))
    }
    if (is(cols, "character") && (length(cols) == 2)) {
        colnames <- colnames(f)
        cols <- match(cols, colnames)
        if (any(is.na(cols)))
            stop("'cols' does not match 2 entries in header of file.")
        skip <- skip + 1
    }
    if (!(is(cols, "numeric") && (length(cols) == 2)))
        stop("'cols' must be a numeric or character vector of length 2 for 'single'.")
    cols <- as(cols, "integer")
    what <- vector("list", length = max(cols))
    what[cols] <- ""
    entries <-f
    tids <- factor(entries[[cols[1]]])
    items <- factor(entries[[cols[2]]])
    ngT <- new("ngTMatrix", i = as.integer(items) - 1L, j = as.integer(tids) -
        1L, Dim = c(length(levels(items)), length(levels(tids))),
        Dimnames = list(levels(items), NULL))
    trans <- as(as(ngT, "ngCMatrix"), "transactions")
    transactionInfo(trans) <- data.frame(transactionID = levels(tids))
    return(trans)
}
