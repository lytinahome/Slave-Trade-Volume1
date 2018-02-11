data{
int level;
int gp1;
int gp2;
int gp3;

int depnum1[gp1];
int arrnum1[gp1];
int route1[gp1];

int depnum2[gp2];
int route2[gp2];

int arrnum3[gp3];
int route3[gp3];
}

parameters {
real<lower=1> num[level];
real<lower = 0, upper = 1> sr[level];  
}

transformed parameters{
real nm[level];
for(i in 1:level) 
{
nm[i]=num[i]*sr[i];
}
}

model{
for (x in 1:gp1)
{
depnum1[x]~poisson(num[route1[x]]);
arrnum1[x]~binomial(depnum1[x],sr[route1[x]]);
}

for (y in 1:gp2)
{
depnum2[y]~poisson(num[route2[y]]);
}

for (z in 1:gp3)
{
arrnum3[z]~poisson(nm[route3[z]]);
}


}








