##'  plattProbabilities
##'
##' calculate predicted probabilities
##' @title Platt's probabilistic output for SVM
##' @param deci  decision values
##' @param label labels in training dataset
##' @return predicted probabilities
##' @export 
##' @author Yi Tang
##' @examples
##' data(iris)
##' x <- iris[1:100, 1:4]
##' y <- iris[1:100, 5]
##' y <- (as.integer(y) - 1) * 2 -1  # -1 or 1
##' m2 <- svm(x,
##'          as.factor(y),
##'          probability=T)
##' pred <- predict(m2,
##'                x,
##'                probability=T,
##'                decision.values=T)
##' deci <- attr(pred, "decision.values")[,1]
##' pred.prob <- attr(pred, "probabilities")[,2]
##' pred.platt.prob <- platt.prob(deci, y)
##' cor(pred.prob, pred.platt.prob)
##' identical(rank(pred.prob),
##'           rank(pred.platt.prob))
##' plot(pred.prob, pred.platt.prob)
plattProbabilities <- function(deci, label){
    ## A Note on Platt’s Probabilistic Outputs for Support Vector Machines, section 3.    
    label <- label == 1
    len <- n <- length(label)
    prior1 <- sum(label)
    prior0 <- n - prior1

    maxiter=100  # Maximum number of iterations
    minstep=1e-10  # Minimum step taken in line search
    sigma=1e-12  # Set to any value > 0
    ## //Construct initial values: target support in array t,
    ## // initial function value in fval
    hiTarget=(prior1+1.0)/(prior1+2.0)
    loTarget=1/(prior0+2.0)
    t <- ifelse(label > 0, hiTarget, loTarget)

    A=0.0
    B=log((prior0+1.0)/(prior1+1.0))
    fval=0.0

    for (i in 1:len) {
        fApB=deci[i]*A+B
        if (fApB >= 0)
            fval = fval +  t[i]*fApB+log(1+exp(-fApB))
        else
            fval = fval +  (t[i]-1)*fApB+log(1+exp(fApB))
    }

    for (it in 1 : maxiter) {
                                        #         //Update Gradient and Hessian (use H’ = H + sigma I)
        h11=h22=sigma
        h21=g1=g2=0.0
        for (i in 1 : len) {
            fApB=deci[i]*A+B
            if (fApB >= 0) {
                p=exp(-fApB)/(1.0+exp(-fApB))
                q=1.0/(1.0+exp(-fApB))
            }
            else {
                p=1.0/(1.0+exp(fApB))
                q=exp(fApB)/(1.0+exp(fApB))
            }
            d2=p*q
            h11 = h11 + deci[i]*deci[i]*d2
            h22 = h22 + d2
            h21 = h21 + deci[i]*d2
            d1=t[i]-p
            g1 = g1 + deci[i]*d1
            g2 = g2 + d1
        }
        if (abs(g1)<1e-5 && abs(g2)<1e-5)  # Stopping criteria
            break
                                        # Compute modified Newton directions
        det=h11*h22-h21*h21
        dA = -(h22*g1-h21*g2)/det
        dB = -(-h21*g1+h11*g2)/det
        gd=g1*dA+g2*dB
        stepsize=1

        while (stepsize >= minstep){  ## //Line search
            newA=A+stepsize*dA
            newB=B+stepsize*dB
            newf=0.0
            for (i in 1 : len) {
                fApB=deci[i]*newA+newB
                if (fApB >= 0)
                    newf = newf +  t[i]*fApB+log(1+exp(-fApB))
                else
                    newf = newf + (t[i]-1)*fApB+log(1+exp(fApB))
            }
            if (newf<fval+0.0001*stepsize*gd){
                A=newA
                B=newB
                fval=newf
                break  # Sufficient decrease satisfied
            }
            else
                stepsize = stepsize / 2.0
        }
        
        if (stepsize < minstep){
                                        # print ’Line search fails’
            break
        }
    }
    if (it >= maxiter){
                                        # print ’Reaching maximum iterations’
    }

                                        # return(list(A,B))
    ## calcualte reutrn period
    prob <- 1 / (1 +  exp(A * deci + B))
    return(prob)
}
