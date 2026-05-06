% Base de conhecimento
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



%exercicio1
pertence(CM,[CM|_]).
pertence(CM,[P|R]):-CM\==P,pertence(CM,R).


aprovado(item(_CM,_,_,NT,FQ)):- NT>=5,FQ>=0.75.

foi_aprovado(RA,CM):-historico(RA,Mats),pertence(item(CM,_,_,NT,FQ),Mats),aprovado(item(CM,_,_,NT,FQ)).

aprovadoMateriaCurso(_,[]).
aprovadoMateriaCurso(RA,[P|R]):-foi_aprovado(RA,P),aprovadoMateriaCurso(RA,R).


concluiu(RA,CC):-curriculo(CC,LM),aprovadoMateriaCurso(RA,LM).

%exercicio2
tem(E,[E|_]).
tem(E,[P|R]):-E\==P,tem(E,R).
tem(E,[P|R]):-E\==P,is_list(P),tem(E,P).


ntem([],_,[]).
ntem([P|R],L,Res):-tem(P,L),ntem(R,L,Res).
ntem([P|R],L,[P|Res]):-not(tem(P,L)),ntem(R,L,Res).

listaAprovados([],[]).
%foi aprovado
listaAprovados([item(CM,_,_,NT,FQ)|R],[CM|Resposta]):-aprovado(item(CM,_,_,NT,FQ)),listaAprovados(R,Resposta).
%nao passou
listaAprovados([item(CM,_,_,NT,FQ)|R],Resposta):-not(aprovado(item(CM,_,_,NT,FQ))),listaAprovados(R,Resposta).


%lista de Aprovados
materias_aprovado(RA,LA):-historico(RA,LM),listaAprovados(LM,LA).

diferente(RA,CC,R):-materias_aprovado(RA,LM),curriculo(CC,LMC),ntem(LMC,LM,R).

tranformaCMemNome([],[]).
tranformaCMemNome([X|Y],[P|R]):-materia(X,P,_),tranformaCMemNome(Y,R).

%not pagina 23 apostila 3


falta(RA,CC,OQUE):-diferente(RA,CC,R),tranformaCMemNome(R,OQUE).

%exercicio3

%oq fazer, pegar as materias que ele passou(Já temos)
%ver se essa materia pertence ao tal curso (já temos, mas sem recursão e sem lista)
%caso ela não pertence ela é extra ent entra no QUAIS

npertence_lista([],_,[]).
npertence_lista([P|R],L,[P|Resposta]):-not(pertence(P,L)),npertence_lista(R,L,Resposta).
npertence_lista([P|R],L,Resposta):-pertence(P,L),npertence_lista(R,L,Resposta).

extra(RA,CC,QUAIS):-materias_aprovado(RA,LMA),curriculo(CC,LM),npertence_lista(LMA,LM,Q),tranformaCMemNome(Q,QUAIS).
% conta elementos de uma lista
tamanho([],0).
tamanho([_|R],N):-
    tamanho(R,N1),
    N is N1 + 1.


%matérias aprovadas que pertencem ao currículo
materiasDoCurso([],_,[]).

materiasDoCurso([P|R],LC,[P|Resposta]):-
    pertence(P,LC),
    materiasDoCurso(R,LC,Resposta).

materiasDoCurso([P|R],LC,Resposta):-
    not(pertence(P,LC)),
    materiasDoCurso(R,LC,Resposta).


% exercício 4
jafoi(CC,RA,QUANTO):-
    materias_aprovado(RA,LMA),
    curriculo(CC,LC),
    materiasDoCurso(LMA,LC,Feitas), % só as obrigatórias
    tamanho(Feitas,NFeitas),
    tamanho(LC,Total),
    QUANTO is (NFeitas * 100) / Total.

