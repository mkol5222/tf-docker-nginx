%{ for user, pass in users ~}
${user}:${pass}
%{ endfor ~}