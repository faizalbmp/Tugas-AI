function [hasil] = hitunglikelihood(attribute,class,x)
    hasil = (1/(mean(attribute(classes == class)))*(22/7))*exp(-(x-(var(attribute(classes == class))))^2/mean(attribute(classes == class)))
%     prior = sum(classes==class)/size(classes,1)

end