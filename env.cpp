// Separable covariance on lattice with AR1 structure in each direction.
#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(CO2);
  DATA_INTEGER(nvar); //total number of env. vars.
  DATA_ARRAY(env);
  DATA_VECTOR(env_mu);
  DATA_VECTOR(env_sc);

  PARAMETER(fsd); //observation error; fixed not estimated
  PARAMETER_VECTOR(slope); //intercept in time series
  PARAMETER_VECTOR(alpha); //trend in time series
  PARAMETER(frho_x); //temporal correlation for env. variables
  PARAMETER_VECTOR(frho_Rx); //unstructured correlations
  PARAMETER_VECTOR(fpsi_x); //process error
  PARAMETER_ARRAY(eps_x);    //random effects for each variable, nt * ni
  
  // 
  using namespace density;
  
  Type ff = 0.;  //joint likelihood

  int nte = env.dim[0];

  //Correlation coefficient and process variances
  vector<Type> psi_x = exp(fpsi_x);

  //Temporal correlation across all covariates
  Type rho_x = 1/(1+exp(-frho_x));
  
  //Covariance matrix among covariates
  UNSTRUCTURED_CORR_t<Type> Sigma_x(frho_Rx);
	ff += AR1(rho_x,Sigma_x)(eps_x);

  matrix<Type> env_hat(nte,nvar);
  for(int j=0;j<nvar;j++){
    for(int t=0;t<nte;t++){
      //observation model
      env_hat(t,j) = eps_x(j,t)*psi_x(j) + alpha(j) + slope(j)*(CO2(t));
      if(env(t,j)>-100){ //only calculate observation model when data exists
        ff -= dnorm(env_hat(t,j), env(t,j), exp(fsd), true);
      }
    }
  }

  REPORT(env_hat);
  REPORT(Sigma_x.cov());
  ADREPORT(env_hat);
  
  return ff;
}
