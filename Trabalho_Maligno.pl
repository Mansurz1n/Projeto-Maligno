
curso(1,informatica).
curso(2,eletro_eletronica).




materia(1,tecnicas_de_programacao,8).
materia(2,programacao_orieNTada_a_objetos,5).
materia(3,estruturas_de_dados,4).
materia(4,topicos_em_metodologias_de_programacao,3).
materia(5,circuitos_eletricos,4).
materia(6,eletronica_digital,5).
materia(7,arquitetura_computadores,6).
materia(8,microcoNTroladores,4).


curriculo(1,[1,2,3,4]).
curriculo(2,[5,6,7,8]).


aluno(12808,jose).
aluno(12080,marcos).
aluno(12909,joao).
aluno(12090,ana).


cursa(12909,1).
cursa(12080,2).
cursa(12090,2).


historico(12808,[item(1,1,2012,3.0,0.77),item(1,2,2013,6.5,0.90),item(5,1,2014,8.0,0.80)]).
historico(12909,[item(1,1,2012,7.0,0.80),item(2,2,2013,8.5,0.80),item(3,1,2014,5.0,0.75)]).
historico(12080,[item(5,1,2012,6.0,0.70),item(5,2,2013,7.5,0.90),item(6,1,2014,5.0,0.90)]).
historico(12090,[item(7,1,2012,6.0,0.75),item(8,2,2014,8.0,0.89),item(5,2,2014,8.0,0.89),item(6,2,2014,8.0,0.89)]).




pertence(CM,[CM|_]).
pertence(CM,[P|R]):-CM\==P,pertence(CM,R).


aprovado(item(_CM,_,_,NT,FQ)):- NT>=5,FQ>=0.75.

foi_aprovado(RA,CM):-historico(RA,Mats),pertence(item(CM,_,_,NT,FQ),Mats),aprovado(item(CM,_,_,NT,FQ)).

aprovadoMateriaCurso(_,[]).
aprovadoMateriaCurso(RA,[P|R]):-foi_aprovado(RA,P),aprovadoMateriaCurso(RA,R).


concluiu(RA,CC):-curriculo(CC,LM),aprovadoMateriaCurso(RA,LM).


%X=listarestante
tem(E,[E|_]).
tem(E,[P|R]):-E\==P,tem(E,R).
tem(E,[P|R]):-E\==P,is_list(P),tem(E,P).


ntem([],_,[]).
ntem([P|R],L,Res):-tem(P,L),ntem(R,L,Res).
ntem([P|R],L,[P|Res]):-not(tem(P,L)),ntem(R,L,Res).

diferente(RA,CC,R):-aprovadoMateriaCurso(RA,LM),curriculo(CC,LMC),ntem(LM,LMC,R).

tranformaCMemNome([],[]).
tranformaCMemNome([X|Y],[P|R]):-materia(X,P,_),tranformaCMemNome(Y,R).

%not pagina 23 apostila 3


falta(RA,CC,OQUE):-diferente(RA,CC,R),tranformaCMemNome(R,OQUE).

