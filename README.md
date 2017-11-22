---
title: "literaturaBR"
output: github_document
---

## literaturaBR: Textos da literatura clássica brasileira para praticar Text Mining

**NOTE**: This package is strictly intented for Portuguese speakers or people fluent in Portuguese. As it does not make any reasonable sense to do Text Mining tasks in a language you are not comfortable with, the documentation and the vignettes of `literaturaBR` shall be provided only in Portuguese.

`literaturaBR` possibilita que usuários R importem da maneira mais fácil possível textos clássicos com o objetivo de realizar tarefas de Text Mining, como Análise de Sentimento e técnicas quantitativas aplicadas a datasets textuais. Um exemplo de utilização do pacote está em [meu site](http://sillasgonzaga.com/post/literaturabr-01/).


Até o momento, estes livros estão disponíveis no pacote:  

* O Alienista, de Machado de Assis;  
* O Ateneu, de Raul Pompeia;  
* A Escrava Isaura, de Bernardo Guimarães;  
* Memórias de um Sargento de Milícias, de Manuel Antonio de Almeida;  
* Memórias Póstumas de Brás Cubas, de Machado de Assis;  

Os livros providenciados pelo `literaturaBR` estão em domínio público e são extraídos do site Wikisource por meio de web scraping. O código escrito para extrair os livros e os converter em dataframe estão presentes na pasta `data-raw/`. 

**Você pode solicitar** um novo livro para o pacote abrindo uma issue neste repositório. Em até duas semanas eu disponibilizo o livro que pedirem.

## Objetivo do pacote

Este pacote, juntamente com meu outro pacote [`lexiconPT`](https://github.com/sillasgonzaga/lexiconPT/), tem o potencial de atrair para o mundo R pessoas de especialidades que não costumam programar, como Letras e História. Se você é estudante desses cursos, tem interesse em usar o pacote `literaturaBR` mas tem pouca experiência em programar com R, [entre em contato comigo](www.sillasgonzaga.com).

Um exemplo de utilização do pacote pode ser encontrado [neste post] no meu site.

## Instalação

Para instalar o pacote, que por enquanto está disponível apenas no Github, rode o comando abaixo:

```r
devtools::install_github("sillasgonzaga/literaturaBR")
```

Para importar o dataset de um livro, basta usar a função `data()`. Você pode conferir os datasets disponíveis no `literaturaBR` com o comando `data(package = 'literaturaBR')`.  

## Agradecimentos

Agradeço ao professor Ariel Levy da UFF por me encorajar a fazer o pacote falando sobre como ele poderia ser útil para disseminar o R em outros departamentos além das exatas e biológicas.  


