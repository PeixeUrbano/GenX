// ****************************************
// Script Gerador de CPF e CNPJ Válidos
// Autor: Marcos Guiga
// Site : Worldigital.co.cc
// Email: marcosguiga@hotmail.com
// Data: 19/12/2010
// ****************************************

function generateRandom(n)
{
    var ranNum = Math.round(Math.random()*n);
    return ranNum;
}

function mod(dividend,divisor)
{
    return Math.round(dividend - (Math.floor(dividend/divisor)*divisor));
}

function generate()
{
    var n = 9;
    var n1 = generateRandom(n);
    var n2 = generateRandom(n);
    var n3 = generateRandom(n);
    var n4 = generateRandom(n);
    var n5 = generateRandom(n);
    var n6 = generateRandom(n);
    var n7 = generateRandom(n);
    var n8 = generateRandom(n);
    var n9 = 0;//generateRandom(n);
    var n10 = 0;//generateRandom(n);
    var n11 = 0;//generateRandom(n);
    var n12 = 1;//generateRandom(n);
    var d1 = n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
    d1 = 11 - ( mod(d1,11) );
    if (d1>=10) d1 = 0;
    var d2 = d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
    d2 = 11 - ( mod(d2,11) );
    if (d2>=10) d2 = 0;
    return ''+n1+n2+n3+n4+n5+n6+n7+n8+n9+n10+n11+n12+d1+d2;
}