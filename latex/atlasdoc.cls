%-------------------------------------------------------------------------------
% Template class for ATLAS documents
%
% See ChangeLog or SVN log for history of changes.
% Responsible: Ian Brock (ian.brock@cern.ch)
%-------------------------------------------------------------------------------
\def\ATPackageVersion{01-06-01}

% --- Class structure: identification part
\ProvidesClass{latex/atlasdoc}[2015/02/08 v.01-06-01 ATLAS document class]
\NeedsTeXFormat{LaTeX2e}

%-------------------------------------------------------------------------------
% More advanced if syntax
\RequirePackage{ifthen}
% Process options. Use kvoptions package.
\RequirePackage{kvoptions}
%\RequirePackage[debugshow]{kvoptions}
\SetupKeyvalOptions{
  family=ADOC,
  prefix=ADOC@
}
\DeclareBoolOption[true]{atlasstyle}
\DeclareBoolOption[false]{coverpage}
\DeclareBoolOption[false]{cernpreprint}
\DeclareBoolOption[false]{preprint}
\DeclareBoolOption[true]{NOTE}
\DeclareBoolOption[false]{PAPER}
\DeclareBoolOption[false]{CONF}
\DeclareBoolOption[false]{PUB}
\DeclareBoolOption[false]{auxmat}
\DeclareBoolOption[true]{maketitle}
\DeclareBoolOption[false]{nomaketitle}
\DeclareBoolOption[false]{letterpaper}
\DeclareStringOption[2013]{texlive}
\DeclareStringOption{paper}
\DeclareBoolOption[true]{newtx}
\DeclareBoolOption[false]{txfonts}
\DeclareBoolOption[false]{libertine}
\DeclareBoolOption[false]{palatino}
\DeclareBoolOption[true]{floatopt}
\DeclareBoolOption[false]{koma}
\DeclareBoolOption[false]{texmf}
\DeclareBoolOption[false]{showframe}
\ProcessKeyvalOptions{ADOC}

% Standard LaTeX options for paper size
%\newif\ifADOC@aivpaper
%\ADOC@aivpapertrue
%\DeclareOption{a4paper}{\PassOptionsToClass{\CurrentOption}{\ADOC@mainclass}} % \ADOC@aivpapertrue} %\def\ADOC@paperstring{a4paper}}
%\DeclareOption{letterpaper}{\PassOptionsToClass{\CurrentOption}{\ADOC@mainclass}} % \ADOC@aivpaperfalse} %\def\ADOC@paperstring{letterpaper}}
%\ProcessOptions\relax
\newcommand*{\ATTeXLiveVersion}{\ADOC@texlive}

\newif\ifADOC@CONFnote
\newif\ifADOC@PUBnote

% ATLAS style needs KOMA-Script
\ifADOC@atlasstyle
  \ADOC@komatrue
\fi

% CERN preprint or auxiliary material
\ifADOC@cernpreprint
  \ADOC@auxmatfalse
  \ADOC@maketitlefalse
\else
  \ifADOC@preprint
    \ADOC@cernpreprinttrue
    \ADOC@auxmatfalse
    \ADOC@maketitlefalse
  \else
    \ifADOC@auxmat
      \ADOC@cernpreprintfalse
      \ADOC@auxmattrue
      \ADOC@maketitlefalse
    \fi
  \fi
\fi

% Type of document
\ifADOC@PAPER
  \ADOC@PAPERtrue
  \ADOC@NOTEfalse
  \ADOC@CONFnotefalse
  \ADOC@PUBnotefalse
\else
  \ifADOC@CONF
    \ADOC@PAPERfalse
    \ADOC@NOTEfalse
    \ADOC@CONFnotetrue
    \ADOC@PUBnotefalse
  \else
    \ifADOC@PUB
      \ADOC@PAPERfalse
      \ADOC@NOTEfalse
      \ADOC@CONFnotefalse
      \ADOC@PUBnotetrue
    \fi
  \fi
\fi

% Decide on the main class
\ifADOC@koma%
  \typeout{atlasdoc: use KOMA-script scrartcl class}
  \def\ADOC@mainclass{scrartcl}
\else
  \typeout{atlasdoc: use standard LaTeX article class}
  \def\ADOC@mainclass{article}
\fi

% Set paper size
\ifx\ADOC@paper\@empty
  %\typeout{atlasdoc: paper option not specified}
  \ifADOC@letterpaper%
    \typeout{atlasdoc: set paper size to letter - deprecated option}
    \def\ADOC@paperstring{letterpaper}
    \PassOptionsToClass{letterpaper}{\ADOC@mainclass}
    \typeout{atlasdoc: paper size set to letter}
  \else
    \def\ADOC@paperstring{a4paper}
    \PassOptionsToClass{a4paper}{\ADOC@mainclass}
    \typeout{atlasdoc: paper size set to default A4}
  \fi
\else
  \def\ADOC@paperstring{\ADOC@paper paper}
  \PassOptionsToClass{\ADOC@paperstring}{\ADOC@mainclass}
  \typeout{atlasdoc: paper is \ADOC@paper, string for class is \ADOC@paperstring}
\fi

% Obsolete command to turn off making title page
\ifADOC@nomaketitle
  \ADOC@maketitlefalse
\fi

% Switch to txfonts for TeX Live <= 2012
% Need to pass this option to atlaspackage as well
\ifthenelse{\ADOC@texlive < 2012 \AND \boolean{ADOC@newtx}}{%
  \typeout{*** atlasdoc: use txfonts instead of newtx}
  \ADOC@newtxfalse
  \ADOC@txfontstrue
  \ifADOC@texmf
    \def\ADOC@atlaspackage{atlaspackage}
  \else
    \def\ADOC@atlaspackage{latex/atlaspackage}
  \fi
  \PassOptionsToPackage{txfonts}{\ADOC@atlaspackage}
}{%
}

%-------------------------------------------------------------------------------
% Defaults for title page
\newdimen\ADOC@skipbeforetitle
\ADOC@skipbeforetitle=60\p@
\newcommand{\skipbeforetitle}[1]{\ADOC@skipbeforetitle=#1}

\def\@title{Dummy title in atlasdoc\\ Use \textbackslash AtlasTitle to set it}
\newcommand{\AtlasTitleText}{Dummy AtlasTitleText in atlasdoc\\ Use \textbackslash AtlasTitle to set it}
\newcommand{\AtlasTitle}[1]{%
  \def\@title{#1}%
  \renewcommand{\AtlasTitleText}{#1}%
}
\def\@author{The ATLAS Collaboration}
\def\@date{\today}

% Draft version 
\def\ADOC@draftversion{}
\newcommand*{\draftversion}[1]{\def\ADOC@draftversion{#1}}
\newcommand*{\AtlasVersion}[1]{\def\ADOC@draftversion{#1}}

% ATLAS reference code - empty by default
% Also create variable with web page
\def\ADOC@refcode{}
\newcommand*{\AtlasRefCode}[1]{\def\ADOC@refcode{#1}}
\newcommand*{\AtlasPaperWebpage}{https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PAPERS/\ADOC@refcode}

% ATLAS note number
\def\ADOC@atlasnote{}
\newcommand*{\AtlasNote}[1]{\def\ADOC@atlasnote{#1}}

% ATLAS date - arXiv submission; to be filled in by the Physics Office
\def\ADOC@atlasdate{\today}
\newcommand*{\AtlasDate}[1]{\def\ADOC@atlasdate{#1}}

% Journal
\def\ADOC@journal{}
\newcommand*{\journal}[1]{\def\ADOC@journal{#1}}
\newcommand*{\AtlasJournal}[1]{\def\ADOC@journal{#1}}

% Preprint
\def\ADOC@preprintnumber{}
\newcommand*{\PreprintIdNumber}[1]{\def\ADOC@preprintnumber{#1}}

% Journal
\def\ADOC@journalref{}
\newcommand*{\AtlasJournalRef}[1]{\def\ADOC@journalref{#1}}

% DOI
\def\ADOC@doi{}
\newcommand*{\AtlasDOI}[1]{\def\ADOC@doi{#1}}

% arXiv
\def\AtlasArXivId{}
\def\AtlasArXivURL{}
\newcommand*{\arXivId}[1]{\def\AtlasArXivId{#1}\def\AtlasArXivURL{http://arXiv.org/abs/#1}}
\newcommand*{\AtlasArXivCat}{[hep-ex]}

% HEP Data
\def\AtlasHepDataRecord{}
\newcommand*{\HepDataRecord}[1]{\def\AtlasHepDataRecord{http://hepdata.cedar.ac.uk/view/ins#1}}

% Submission details
\def\ADOC@subprepend{To be submitted to:}
\newcommand*{\subprepend}[1]{\def\ADOC@subprepend{#1}}

% Abstract text
\def\AtlasAbstractText{}
\newcommand{\AtlasAbstract}[1]{\def\AtlasAbstractText{#1}}
\newcommand{\abstracttext}[1]{\def\AtlasAbstractText{#1}}

%-------------------------------------------------------------------------------
% Invoke main class
\ifADOC@koma%
  \LoadClass[titlepage,11pt]{scrartcl}
  %\LoadClass[titlepage,11pt,twoside=semi]{scrartcl}
  %\LoadClass[titlepage,\ADOC@paperstring,11pt,twoside=semi]{scrartcl}
\else
  \LoadClass[titlepage,11pt]{article}
  %\LoadClass[titlepage,\ADOC@paperstring,11pt]{article}
\fi

% Turn on bold math when using \bfseries
\def\bfseries{\fontseries\bfdefault\selectfont\boldmath}

% Set KOMA-script options for ATLAS style
\ifADOC@atlasstyle
  \KOMAoptions{headinclude=true, footinclude=false}
  \KOMAoptions{DIV=14,BCOR=5mm}
  %\KOMAoptions{headings=normal}
  \KOMAoptions{parskip=half}
  \addtokomafont{disposition}{\rmfamily}
  \addtokomafont{part}{\LARGE}
  \addtokomafont{descriptionlabel}{\rmfamily}
  %\setkomafont{pageheadfoot}{\normalsize\sffamily}
  \setkomafont{pagehead}{\normalsize\rmfamily}
  \setkomafont{caption}{\normalfont\small}
  \setcapindent{0pt}
  \deffootnote[1em]{1em}{1em}{\textsuperscript{\thefootnotemark}\ }
\else
  \RequirePackage[centering,scale=0.75,headheight=16pt]{geometry}
  %\RequirePackage[\ADOC@paperstring,centering,scale=0.75]{geometry}
\fi

% ATLAS draft cover pages for papers, PUB and CONF notes
\ifADOC@texmf
  \def\ADOC@atlascover{atlascover}
\else
  \def\ADOC@atlascover{latex/atlascover}
\fi
\ifADOC@coverpage
  \ifADOC@CONFnote
    \PassOptionsToPackage{CONF,atlasdoc}{\ADOC@atlascover}
  \else
    \ifADOC@PUBnote
      \PassOptionsToPackage{PUB,atlasdoc}{\ADOC@atlascover}
    \else
      \PassOptionsToPackage{atlasdoc}{\ADOC@atlascover}
    \fi
  \fi
  \RequirePackage{\ADOC@atlascover}
\else
  % CERN preprint cover page
  \ifADOC@cernpreprint
    \PassOptionsToPackage{atlasdoc}{\ADOC@atlascover}
    \RequirePackage{\ADOC@atlascover}
  \fi

  % Auxiliary material cover page
  \ifADOC@auxmat
    \PassOptionsToPackage{atlasdoc}{\ADOC@atlascover}
    \RequirePackage{\ADOC@atlascover}
  \fi
\fi

% Remove the numbers from all the headings (\section, \subsection, etc.)
%\setcounter{secnumdepth}{-1}

% Required packages
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{babel}
% hyperref is needed in many places, so include it here
\RequirePackage{hyperref}

% Font(s)
\ifADOC@txfonts
  % Needs special amsmath code in atlaspackage
  \typeout{atlasdoc: using txfonts}
  \RequirePackage[varg]{txfonts}
  \RequirePackage[T1]{fontenc}
\else
  \ifADOC@libertine
    \typeout{atlasdoc: using Libertine fonts}
    \RequirePackage{libertine}
    \RequirePackage[T1]{fontenc}
    \RequirePackage[libertine]{newtxmath}
  \else
    \ifADOC@palatino
      \typeout{atlasdoc: using Palatino fonts}
      % Palatino for rm and math | Helvetica for ss | Courier for tt
      \RequirePackage{mathpazo} % math & rm
      \linespread{1.05}        % Palatino needs more leading (space between lines)
      \RequirePackage[scaled]{helvet} % ss
      \RequirePackage{courier} % tt
      \normalfont
      \RequirePackage[T1]{fontenc}
    \else
      \typeout{atlasdoc: using newtx fonts package}
      \RequirePackage{newtxtext}
      \ifthenelse{\ADOC@texlive < 2013}{%
        \typeout{*** atlasdoc: include amsmath before newtxmath}
        \RequirePackage{amsmath}
      }{%
      }
      \RequirePackage{newtxmath}
    \fi
  \fi
\fi

% Adjust float settings to try to avoid problems.
% These follow the UK FAQ - see also P.199-200 of the LaTeX Book
\ifADOC@floatopt
  \renewcommand{\topfraction}{0.85}
  \renewcommand{\bottomfraction}{0.70}
  \renewcommand{\textfraction}{0.15}
  \renewcommand{\floatpagefraction}{0.66}
  \renewcommand{\dbltopfraction}{0.66}
  \renewcommand{\dblfloatpagefraction}{0.66}
  \setcounter{topnumber}{9}
  \setcounter{bottomnumber}{9}
  \setcounter{totalnumber}{20}
\fi

% Add ability to include line numbers
\RequirePackage{lineno}
% If you have an old lineno or do not have it, you can get it from the latex/other directory
% \RequirePackage{latex/other/lineno}
% \nolinenumbers
\ifADOC@showframe
  \RequirePackage{showframe}
\fi

% Compute the time in hours and minutes; make new variables \timehh and \timemm
\newcount\timehh\newcount\timemm
\timehh=\time 
\divide\timehh by 60 \timemm=\time
\count255=\timehh\multiply\count255 by -60 \advance\timemm by \count255
% Now make a string with date and time
\newcommand{\dateandtime}{\today \ --
  \ifnum\timehh<10 0\fi\number\timehh:\ifnum\timemm<10 0\fi\number\timemm}
% \RequirePackage{scrdate,scrtime}

% Draft heading/footer code
\newcommand{\draftheading}{%
  \ifADOC@koma
    \RequirePackage[headsepline]{scrpage2}
    \ihead{}
    \chead[]{\fbox{\textsf\bfseries DRAFT}}
    \ohead{}
    \ifoot{\dateandtime}
    %\cfoot{atlasdoc: \ATPackageVersion}
    \cfoot{}
    \ofoot{\thepage}
    \pagestyle{scrheadings}
  \else
    \RequirePackage{fancyhdr}
    \chead[]{\fbox{\textsf\bfseries DRAFT}}
    \rhead{}
    \lfoot{\dateandtime}
    %\cfoot{atlasdoc: \ATPackageVersion}
    \cfoot{}
    \rfoot{\thepage}
    \setlength\headheight{16pt}
    \pagestyle{fancy}
  \fi
}

\newcommand{\olddraftheading}{%
  % Put date and time in header
  \markboth
  % --- Left mark
  {\hspace*{\fill}{\fbox{\textbf{DRAFT}}}
    \hspace*{\fill}
    \protect\makebox[0pt][r]{\protect\small\textsl{\dateandtime}}
  }%--- right mark
  {\protect\makebox[0pt][l]{\protect\small\textsl{\dateandtime}}
    \hspace*{\fill}
    {\fbox{\textbf{DRAFT}}}
    \hspace*{\fill}}
  \pagestyle{myheadings}
}

% Include fancier header and footer for auxiliary material document
\ifADOC@auxmat
  \ifADOC@koma
    \RequirePackage[headsepline]{scrpage2}
    \chead{ATLAS Collaboration -- arXiv:\AtlasArXivId\ \AtlasArXivCat}
  \else
    \RequirePackage{fancyhdr}
    \lhead{}
    \chead{ATLAS Collaboration -- arXiv:\AtlasArXivId\ \AtlasArXivCat}
    \rhead{}
  \fi
\fi

% Title page design
\newcommand{\AtlasTitleHeader}{%
  \begin{minipage}{\linewidth}
    \begin{minipage}[c][35mm][t]{0.25\linewidth}
      \includegraphics[height=30mm]{AT_atlaslogo}
    \end{minipage}
    \hspace*{\fill}
    \begin{minipage}[c][35mm][c]{0.40\linewidth}
      \centering
        {\fontfamily{phv}\bfseries\fontsize{20}{24}\selectfont
          \ifADOC@PAPER
            \textsf{ATLAS PAPER}\par
          \else
            \textsf{ATLAS NOTE}\par
          \fi
        }
        \vspace*{2ex}
        % ATLAS note number, if any 
        \ifx\ADOC@atlasnote\@empty
          % ATLAS reference code, if any and no note number given
          \ifx\ADOC@refcode\@empty
            \mbox{}%
          \else 
            {\Large \ADOC@refcode}\par
          \fi
        \else
          {\Large \ADOC@atlasnote}\par
        \fi
        \vspace*{2ex}
        % Date, if any
        \ifx\@date\@empty
          \mbox{}\par
        \else
          \@date\par
        \fi
    \end{minipage}
    \hspace*{\fill}
    \begin{minipage}[c][35mm][t]{0.25\linewidth}
      \flushright\includegraphics[height=25mm]{AT_cernlogo}
      \ifx\ADOC@draftversion\@empty
        \relax
      \else
        \flushright\normalsize Draft version \ADOC@draftversion
      \fi
    \end{minipage}
  \end{minipage}\par
}

\newcommand{\AtlasTitleBody}{%
  {\centering
    {\bfseries\fontsize{16}{19.2}\selectfont \@title \par}
    \vskip 3em
    {\large
     \lineskip .75em
     \begin{tabular}[t]{c}
       \@author
     \end{tabular}\par}
  }\par
  \vspace{\stretch{0.5}}
  % Astract
  \if\AtlasAbstractText\@empty
    \mbox{}
  \else
    {\centering
      \bfseries\fontsize{12}{14.4}\selectfont
      \abstractname\par
    }
    {\fontseries{m}\fontsize{11}{13.2}\selectfont%
      \begin{quote}
        %\setlength{\parindent}{0pt}\setlength{\parskip}{0.5ex}\noindent\AtlasAbstractText
        \AtlasAbstractText
      \end{quote}
    }
  \fi
  % Submission details
  \ifx\ADOC@journal\@empty
    \relax
  \else
    \ifADOC@PAPER
      \vspace{\stretch{1}}
      \noindent\begin{minipage}[c]{\linewidth}
        \centering
        \ADOC@subprepend\ \textit{\ADOC@journal}
      \end{minipage}
      %{\submitted}\par
    \fi
  \fi
}

\newcommand{\AtlasTitleFooter}{%
  % Copyright
  \parbox[b]{\linewidth}{%
    \small
    \copyright\ \the\year\ CERN for the benefit of the ATLAS Collaboration.\newline
    Reproduction of this article or parts of it is allowed as specified in the CC-BY-3.0 license.
  }\par
  % Thanks
  \@thanks
}

% Follow style of atlascover to create title page.
\renewcommand\maketitle{%
  \thispagestyle{empty}
%  \pagestyle{plain}
  \pagenumbering{arabic}
  \noindent{\AtlasTitleHeader}
  \vfill
  \noindent{\AtlasTitleBody}
  \vfill
  \noindent{\AtlasTitleFooter}
  \clearpage
%  \setcounter{page}{1}%
%  \global\let\thanks\relax
%  \global\let\maketitle\relax
%  \global\let\@thanks\@empty
%  \global\let\@author\@empty
%  \global\let\@date\@empty
%  \global\let\@title\@empty
%  \global\let\title\relax
%  \global\let\author\relax
%  \global\let\date\relax
%  \global\let\and\relax
%  \ifADOC@atlasstyle
%    \deffootnote{1em}{1em}{\textsuperscript{\thefootnotemark}\ }
%  \fi
}

\AtBeginDocument{%
  % If selected, generate ATLAS Cover Page
  %\typeout{atlasdoc is producing the cover and title pages}
  \ifADOC@coverpage
    \nolinenumbers
    \ACOV@PrintAtlasCover
    \ACOV@PrintAtlasCoverPageTwo
  \fi
  \setcounter{page}{1}
  % Add line numbers
  \ifx\ADOC@draftversion\@empty%
  \else \linenumbers
  \fi
  % If selected, generate CERN preprint front page
  \ifADOC@cernpreprint
    \typeout{atlasdoc: making CERN preprint front page}
    \ACOV@PrintCERNPreprintCover
  \else
    % If selected, generate ATLAS auxiliary material front page
    \ifADOC@auxmat
      \typeout{atlasdoc: making auxiliary material front page}
      \ACOV@PrintAuxmatCover
    % Standard title page
    \else
      \ifADOC@maketitle
        \typeout{atlasdoc: making standard document title page}
        \maketitle
      \fi
    \fi
  \fi
  \clearpage
  % Add draft heading and line numbers
  \ifx\ADOC@draftversion\@empty%
  \else \draftheading 
  \fi
}

\endinput
