Polynomial <- function(...) {
  # Takes in any number of arguments to construct a vector
  terms <- as.vector(list(...), mode="numeric")
  class(terms) <- "Polynomial"
  
  return(terms)
}

Ops.Polynomial <- function(e1, e2=NULL) {
  # If operator is binary, make both polynomials have the "same" length
  # by filling in non-specified terms of shorter polynomial with zeroes
  if (!is.null(e2)) {
    # Keep track of length of polynomials without trailing zeroes
    length.e1_nonzero <- length(e1)
    length.e2_nonzero <- length(e2)
    
    # Fill poly with zeroes until it has result_length length
    fill_in <- function(poly, result_length) {
      while (length(poly) < result_length) {
        poly <- append(poly, 0)
      }
      
      return(poly)
    }
    
    if (length(e1) < length(e2)) {
      e1 <- fill_in(e1, length(e2))
    } else {
      e2 <- fill_in(e2, length(e1))
    }
  }
  
  # ==== Unary Operators ====
  # Unary Operator: "-"
  if (.Generic == "-" & is.null(e2)) {
    return(do.call(what=Polynomial, args=as.list(-c(e1))))
  }
  
  # ==== Binary Operators ====
  # Addition Operator
  else if (.Generic == "+") {
    sum <- list()
    
    for (i in seq(1, length(e1))) {
      sum <- append(sum, e1[i] + e2[i])
    }
    
    return(do.call(what=Polynomial, args=sum))
  }
  
  # Subtraction Operator
  else if (.Generic == "-") {
    # Simply flip the signs of the second polynomial and 
    # use the existing addition method
    return(e1 + -e2)
  }
  
  # Multiplication operator
  else if (.Generic == "*") {
    # Short Summary:
    # 1. For every term in the first polynomial, multiply it by 
    #    each term in the second polynomial
    # 2. Add up the results
    
    # Degree of result
    # (degree of poly 1) + (degree of poly 2)
    result <- as.list(rep(0, length.e1_nonzero + length.e2_nonzero))
    
    current_power_term1 <- 0
    
    for (t1 in e1) {
      current_power_term2 <- 0
      
      for (t2 in e2) {
        result_term <- t1 * t2
        result_term_power <- current_power_term1 + current_power_term2
        
        result[[result_term_power + 1]] <- result[[result_term_power + 1]] + result_term
        
        current_power_term2 <- current_power_term2 + 1
      }
      
      current_power_term1 <- current_power_term1 + 1
    }
    
    return(do.call(what=Polynomial, args=result))
  }
}

# Change how polynomials are printed out
print.Polynomial <- function(poly) {
  poly_str <- ""
  
  for (degree in seq(0, length(poly) - 1)) {
    term <- poly[degree + 1]
    
    if (degree == length(poly) - 1) {
      # Last term, don't add "+" after
      poly_str <- paste0(poly_str, term, "x^", degree)
    } else {
      poly_str <- paste0(poly_str, term, "x^", degree, " + ") 
    }
  }
  
  print(poly_str)
}

# Evaluate poylynomial at a number
plot.Polynomial <- function(polynom, ...) {
  eval_poly <- function(x) {
    result <- 0
    pow <- 0
    
    for (term in polynom) {
      result <- result + term * x^pow
      pow <- pow + 1
    }
    
    return(result)
  }
  
  curve(eval_poly, ylab="f(x)", ...)
}