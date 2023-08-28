-- Queries / DML

--1. RAs, Nomes e Sobrenomes dos Alunos, Nomes dos Cursos e Períodos das Turmas
SELECT A.RA, A.Nome_Aluno, A.Sobrenome_Aluno, T.Periodo, C.Nome_Curso
FROM Aluno A
INNER JOIN Curso C ON C.Cod_Curso = A.Cod_Curso
INNER JOIN Turma T ON A.Cod_Turma = T.Cod_Turma
ORDER BY A.Nome_Aluno;

--2. Todas as disciplinas cursadas por um aluno, com suas respectivas notas
SLECT A.Nome_Aluno, A.Sobrenome_Aluno, D.Nome_Disciplina, DH.notas
FROM Aluno A
INNER JOIN Aluno_Disc AD ON A.RA = AD.RA
INNER JOIN Disciplina D ON AD.Cod_Disciplina = D.Cod_Disciplina
INNER JOIN Historico H ON A.RA = H.RA
INNER JOIN Disc_Hist DH ON H.Cod_Historico = DH.Cod_Historico
WHERE A.RA = 3;

--3 Nomes e Sobrenomes dos professores, e disciplinas que ministram
SELECT CONCAT(P.Nome_Professor, ' ',P.Sobrenome_Professor) AS Docente,
D.Nome_Disciplina, D.Carga_Horaria
FROM Professor P
INNER JOIN Prof_Disciplina PD ON P.Cod_Professor = PD.Cod_Professor
INNER JOIN Disciplina D ON D.Cod_Disciplina = PD.Cod_Disciplina
ORDER BY D.Nome_Disciplina;

