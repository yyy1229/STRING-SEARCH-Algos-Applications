pkgname <- "Bruteforce"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('Bruteforce')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("baseline")
### * baseline

flush(stderr()); flush(stdout())

### Name: baseline
### Title: baseline
### Aliases: baseline

### ** Examples

require(Bruteforce)
s <- ("abc")
p <- ("b")
print(baseline("abc", "b"))




cleanEx()
nameEx("match")
### * match

flush(stderr()); flush(stdout())

### Name: match
### Title: match
### Aliases: match

### ** Examples

require(Bruteforce)
s <- ("abc")
p <- ("b")
i <- 1
print(match("abc", "b", 1))




cleanEx()
nameEx("rabin_karp")
### * rabin_karp

flush(stderr()); flush(stdout())

### Name: rabin_karp
### Title: rabin_karp
### Aliases: rabin_karp

### ** Examples

require(Bruteforce)
s <- ("abc")
p <- ("b")
print(rabin_karp("abc", "b"))




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
