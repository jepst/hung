#!/usr/bin/perl

### This work is licensed under the Creative Commons Attribution 4.0 
### International License. To view a copy of this license, visit 
### http://creativecommons.org/licenses/by/4.0/.
###
### Tim Talpas
### http://www.jargot.com/hvc
###

use utf8;
binmode STDOUT, ":utf8";
use Encode qw(encode decode);

print "Content-type: text/html\n\n";

if (!$ENV{QUERY_STRING}) {
    print "<HTML><HEAD>\n";
    print "<META http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n";
    print "<META name=\"language\" content=\"hungarian, hu\">\n";
    print "<TITLE>RVC</TITLE></HEAD>\n";
    print "<BODY>\n";
    print "\n";
    print "<CENTER><H1>MAGYAR IGÉK</H1></CENTER><P>\n";
#    print "<CENTER><TABLE BORDER=2><TR><TD><IMG SRC=\"/images/roma.gif\"></TD></TR></TABLE></CENTER><P>\n";
    print "<DD>Welcome! Please note that output from this script will include some Unicode characters. The hungarian O double acute <B>ő</B> and U double acute <B>ű</B>should appear normally, if not, make sure your browser supports Unicode. This is a work in progress, but if you have corrections, please email them to <A HREF=\"mailto:magyar\@zece.com\">magyar\@zece.com</A>.\n";
    print "<P>\n";
    print "<DD>Enter the verb in the stem or 3rd Person singular form, <B>not the infinitive!</B>, In all lower case. <B>No capitals!</B> For example, if you want to conjugate the verb \"to drink\", you would enter \"iszik\", not \"inni\". Also, do not enter verbs with attached verb particles, instead, check the circle next to the desired particle listed below. For example, instead of entering \"bemegy\", simply enter \"megy\" and check the circle next to \"be-\" in the list. To enter special characters, use the identifying mark (/ : or //) after the letter. Thus, you would enter:\n";
    print "<P>\n";
    print "<CENTER><TABLE CELLPADDING=2 BORDER>\n";
    print "<TR>\n";
    print "<TD><B>acute accent</B></TD>\n";
    print "<TD><B></B>se/ta/l = sétál \"walk\"</TD>\n";
    print "</TR><TR>\n";
    print "<TD><B>diaeresis</B></TD>\n";
    print "<TD><B></B>u:l = ül \"sit\"</TD>\n";
    print "</TR><TR>\n";
    print "<TD><B>double accute accent</B></TD>\n";
    print "<TD><B></B>fo//z = főz \"cook\"</TD>\n";
    print "</TR>\n";
    print "</TABLE></CENTER>\n";
    print "<HR>\n";
    print "<FORM METHOD=POST ACTION=\"http://www.jargot.com/hvc/hvcul2.pl?conj\">\n";
    print "<CENTER>\n";
    print "Verb: <INPUT NAME=verb>";
    print "<HR>\n";
    print "<B>Verb Particle:</B><BR>\n";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"be\">be- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"bele\">bele- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"le\">le- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"ki\">ki- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"fel\">fel- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"föl\">föl- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"el\">el- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"vissza\">vissza- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"át\">át-<BR>\n";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"végig\">végig- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"ide\">ide- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"oda\">oda- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"rá\">rá- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"haza\">haza- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"össze\">össze- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"szét\">szét- ";
    print "<INPUT TYPE=RADIO NAME=particle VALUE=\"meg\">meg- ";
    print "\n<BR>\n<HR>\n";
    print " <INPUT TYPE=SUBMIT VALUE=\" Submit \">";
    print " <INPUT TYPE=RESET VALUE=\" Clear \">\n";
    print "<BR>\n";
    exit;
} else {
    read(STDIN,$input,$ENV{'CONTENT_LENGTH'});
    @input = split(/&/,$input);
    $incount = 0;
    foreach $i (0 .. @input) {
        $input[$i] =~ s/\+/ /g;
        ($key, $val) = split(/=/,$input[$i],2);
       $key =~ s/%(..)/pack("C*",hex($1))/ge;
       $val =~ s/%(..)/pack("C*",hex($1))/ge;
        $KEYS[$incount] = $key;
        $VALS[$incount] = $val;
        $ALL{$key} .= "\0" if (defined($ALL{$key}));
        $ALL{$key} .= $val;
        $incount++;
    }

   $verb = &char_trans(decode("UTF-8",$ALL{verb}));
   $particle = &char_trans(decode("UTF-8",$ALL{particle}));

    @TENSEDEF = ("<FONT COLOR=0000CC>én</FONT>",
                            "<FONT COLOR=0000CC>te</FONT>",
                            "<FONT COLOR=0000CC>ő</FONT>",
                            "<FONT COLOR=0000CC>mi</FONT>", 
                            "<FONT COLOR=0000CC>ti</FONT>", 
                            "<FONT COLOR=0000CC>ők</FONT>",
                            "<FONT COLOR=009900>én/téged</FONT>");

    print "<HTML><HEAD>\n";
    print "<META http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n";
    print "<TITLE>HVC</TITLE></HEAD>\n";
    print "<BODY BGCOLOR=#FFFFFF>\n";
    print "\n";

########## import hvc2.pl code here
##########

@TENSE = ("én", "te", "ő", "mi", "ti", "ők");
#
############  PRESENT TENSE INDEFINITE
#
@IND_PRES_BACK1 = ('ok', 'sz', '', 'unk', 'tok', 'nak');
@IND_PRES_BACK1a = @IND_PRES_BACK1;
@IND_PRES_BACK2 = ('ok', 'asz', '', 'unk', 'otok', 'anak');
@IND_PRES_BACK3 = ('ok', 'ol', '', 'unk', 'tok', 'nak');
@IND_PRES_BACK3a = ('ok', 'ol', '', 'unk', 'otok', 'anak');
@IND_PRES_BACK3b = ('ok', 'ol', '', 'unk', 'otok', 'anak');
@IND_PRES_BACK4 = @IND_PRES_BACK1;
@IND_PRES_BACK5 = @IND_PRES_BACK1;
@IND_PRES_FRNT1 = ('ek', 'sz', '', 'ünk', 'tek', 'nek');
@IND_PRES_FRNT1a = @IND_PRES_FRNT1;
@IND_PRES_FRNT2 = ('ek', 'esz', '', 'ünk', 'etek', 'enek');
@IND_PRES_FRNT3 = ('ek', 'el', '', 'ünk', 'tek', 'nek');
@IND_PRES_FRNT3a = ('ek', 'el', '', 'ünk', 'etek', 'enek');
@IND_PRES_FRNT4 = @IND_PRES_FRNT1;
@IND_PRES_FRNT5 = @IND_PRES_FRNT1;
@IND_PRES_FRNR1 = ('ök', 'sz', '', 'ünk', 'tök', 'nek');
@IND_PRES_FRNR1a = @IND_PRES_FRNR1;
@IND_PRES_FRNR2 = ('ök', 'esz', '', 'ünk', 'ötök', 'enek');
@IND_PRES_FRNR2a = @IND_PRES_FRNR2;
@IND_PRES_FRNR3 = ('ök', 'öl', '', 'ünk', 'tök', 'nek');
@IND_PRES_FRNR3a = ('ök', 'öl', '', 'ünk', 'ötök', 'enek');
@IND_PRES_FRNR4 = @IND_PRES_FRNR1;
@IND_PRES_FRNR5 = @IND_PRES_FRNR1;
@IND_PRES_BACK2a = @IND_PRES_BACK2;
@IND_PRES_FRNT2a = @IND_PRES_FRNT2;
@IND_PRES_FRNR2a = @IND_PRES_FRNR2;
#
############ PRESENT TENSE DEFINITE
#
@DEF_PRES_BACK1 = ('om', 'od', 'ja', 'juk', 'játok', 'ják', 'lak');
@DEF_PRES_BACK1a = ('om', 'od', 'ja', 'juk', 'játok', 'ják', 'lak');
@DEF_PRES_FRNT1 = ('em', 'ed', 'i', 'jük', 'itek', 'ik', 'lek');
@DEF_PRES_FRNT1a = ('em', 'ed', 'i', 'jük', 'itek', 'ik', 'lek');
@DEF_PRES_FRNR1 = ('öm', 'öd', 'i', 'jük', 'itek', 'ik', 'lek');
@DEF_PRES_FRNR1a = ('öm', 'öd', 'i', 'jük', 'itek', 'ik', 'lek');
@DEF_PRES_BACK2 = ('om', 'od', 'ja', 'juk', 'játok', 'ják', 'alak');
@DEF_PRES_FRNT2 = ('em', 'ed', 'i', 'jük', 'itek', 'ik', 'elek');
@DEF_PRES_FRNR2 = ('öm', 'öd', 'i', 'jük', 'itek', 'ik', 'elek');
@DEF_PRES_BACK3 = @DEF_PRES_BACK1;
@DEF_PRES_BACK3a = ('om', 'od', 'ja', 'juk', 'játok', 'ják', 'alak');
@DEF_PRES_BACK3b = ('om', 'od', 'ja', 'juk', 'játok', 'ják', 'alak');
@DEF_PRES_FRNT3 = @DEF_PRES_FRNT1;
@DEF_PRES_FRNT3a = ('em', 'ed', 'i', 'jük', 'itek', 'ik', 'elek');
@DEF_PRES_FRNR3 = @DEF_PRES_FRNR1;
@DEF_PRES_FRNR3a = ('öm', 'öd', 'i', 'jük', 'itek', 'ik', 'elek');
@DEF_PRES_BACK4 = @DEF_PRES_BACK1;
@DEF_PRES_FRNT4 = @DEF_PRES_FRNT1;
@DEF_PRES_FRNR4 = @DEF_PRES_FRNR1;
@DEF_PRES_BACK5 = @DEF_PRES_BACK1;
@DEF_PRES_FRNT5 = @DEF_PRES_FRNT1;
@DEF_PRES_FRNR5 = @DEF_PRES_FRNR1;
@DEF_PRES_BACK2a = @DEF_PRES_BACK2;
@DEF_PRES_FRNT2a = @DEF_PRES_FRNT2;
@DEF_PRES_FRNR2a = @DEF_PRES_FRNR2;
#
############ FUTURE TENSES
#
@IND_FUTURE = ('fogok','fogsz','fog','fogunk','fogtok','fognak');
@DEF_FUTURE = ('fogom','fogod','fogja','fogjuk','fogjátok','fogják','foglak');
#
############ PAST TENSE INDEFINITE
#
@IND_PAST_BACK2 = ('ottam', 'ottál', 'ott', 'ottunk', 'ottatok', 'ottak');
@IND_PAST_BACK4 = ('tam', 'tál', 't', 'tunk', 'tatok', 'tak');
@IND_PAST_BACK1 = ('tam', 'tál', 'ott', 'tunk', 'tatok', 'tak');
@IND_PAST_BACK1a = ('ttam', 'ttál', 'tt', 'ttunk', 'ttatok', 'ttak');
@IND_PAST_BACK3 = @IND_PAST_BACK1;
@IND_PAST_BACK3a = @IND_PAST_BACK4;
@IND_PAST_BACK3b = @IND_PAST_BACK2;
@IND_PAST_BACK5 = @IND_PAST_BACK2;
@IND_PAST_FRNT2 = ('ettem', 'ettél', 'ett', 'ettünk', 'ettetek', 'ettek');
@IND_PAST_FRNT4 = ('tem', 'tél', 't', 'tünk', 'tetek', 'tek');
@IND_PAST_FRNT1 = ('tem', 'tél', 'ett', 'tünk', 'tetek', 'tek');
@IND_PAST_FRNT1a = ('ttem', 'ttél', 'tt', 'ttünk', 'ttetek', 'ttek');
@IND_PAST_FRNT3 = @IND_PAST_FRNT1;
@IND_PAST_FRNT3a = @IND_PAST_FRNT4;
@IND_PAST_FRNT5 = @IND_PAST_FRNT2;
@IND_PAST_FRNR2 = ('öttem', 'öttél', 'ött', 'öttünk', 'öttetek', 'öttek');
@IND_PAST_FRNR4 = ('tem', 'tél', 't', 'tünk', 'tetek', 'tek');
@IND_PAST_FRNR1 = ('tem', 'tél', 'ött', 'tünk', 'tetek', 'tek');
@IND_PAST_FRNR1a = ('ttem', 'ttél', 'tt', 'ttünk', 'ttetek', 'ttek');
@IND_PAST_FRNR3 = @IND_PAST_FRNR1;
@IND_PAST_FRNR3a = @IND_PAST_FRNR4;
@IND_PAST_FRNR5 = @IND_PAST_FRNR2;
@IND_PAST_BACK2a = @IND_PAST_BACK1;
@IND_PAST_FRNT2a = @IND_PAST_FRNT1;
@IND_PAST_FRNR2a = @IND_PAST_FRNR1;
#
############ PAST TENSE DEFINITE
#
@DEF_PAST_BACK2 = ('ottam','ottad','otta','ottuk','ottátok','ották','ottalak');
@DEF_PAST_BACK4 = ('tam', 'tad', 'ta', 'tuk', 'tátok', 'ták', 'talak');
@DEF_PAST_BACK1 = ('tam', 'tad', 'ta', 'tuk', 'tátok', 'ták', 'talak');
@DEF_PAST_BACK1a = ('ttam','ttad','tta','ttuk','ttátok','tták','ttalak');
@DEF_PAST_BACK3 = @DEF_PAST_BACK1;
@DEF_PAST_BACK3a = @DEF_PAST_BACK4;
@DEF_PAST_BACK3b = @DEF_PAST_BACK2;
@DEF_PAST_BACK5 = @DEF_PAST_BACK2;
@DEF_PAST_FRNT2 = ('ettem','etted','ette','ettük','ettétek','ették','ettelek');
@DEF_PAST_FRNT4 = ('tem', 'ted', 'te', 'tük', 'tétek', 'ték', 'telek');
@DEF_PAST_FRNT1 = ('tem', 'ted', 'te', 'tük', 'tétek', 'ték', 'telek');
@DEF_PAST_FRNT1a = ('ttem','tted','tte','ttük','ttétek','tték','ttelek');
@DEF_PAST_FRNT3 = @DEF_PAST_FRNT1;
@DEF_PAST_FRNT3a = @DEF_PAST_FRNT4;
@DEF_PAST_FRNT5 = @DEF_PAST_FRNT2;
@DEF_PAST_FRNR2 = ('öttem','ötted','ötte','öttük','öttétek','ötték','öttelek');
@DEF_PAST_FRNR4 = ('tem', 'ted', 'te', 'tük', 'tétek', 'ték','telek');
@DEF_PAST_FRNR1 = ('tem', 'ted', 'te', 'tük', 'tétek', 'ték','telek');
@DEF_PAST_FRNR1a = ('ttem','tted','tte','ttük','ttétek','tték','ttelek');
@DEF_PAST_FRNR3a = @DEF_PAST_FRNR4;
@DEF_PAST_FRNR3 = @DEF_PAST_FRNR1;
@DEF_PAST_FRNR5 = @DEF_PAST_FRNR2;
@DEF_PAST_BACK2a = @DEF_PAST_BACK1;
@DEF_PAST_FRNT2a = @DEF_PAST_FRNT1;
@DEF_PAST_FRNR2a = @DEF_PAST_FRNR1;
#
############ CONDITIONAL TENSES INDEFINITE
#
@IND_COND_BACK1 = ('nék', 'nál', 'na', 'nánk', 'nátok', 'nának');
@IND_COND_BACK2 = ('anék', 'anál', 'ana', 'anánk', 'anátok', 'anának');
@IND_COND_BACK1a = @IND_COND_BACK1;
@IND_COND_BACK3 = @IND_COND_BACK1;
@IND_COND_BACK3a = @IND_COND_BACK1;
@IND_COND_BACK3b = @IND_COND_BACK2;
@IND_COND_BACK4 = @IND_COND_BACK1;
@IND_COND_BACK5 = @IND_COND_BACK1;
@IND_COND_FRNT1 = ('nék', 'nél', 'ne', 'nénk', 'nétek', 'nének');
@IND_COND_FRNT2 = ('enék', 'enél', 'ene', 'enénk', 'enétek', 'enének');
@IND_COND_FRNT1a = @IND_COND_FRNT1;
@IND_COND_FRNT3 = @IND_COND_FRNT1;
@IND_COND_FRNT3a = @IND_COND_FRNT1;
@IND_COND_FRNT4 = @IND_COND_FRNT1;
@IND_COND_FRNT5 = @IND_COND_FRNT1;
@IND_COND_FRNR1 = ('nék', 'nél', 'ne', 'nénk', 'nétek', 'nének');
@IND_COND_FRNR2 = ('önék', 'önél', 'öne', 'önénk', 'önétek', 'önének');
@IND_COND_FRNR1a = @IND_COND_FRNR1;
@IND_COND_FRNR3 = @IND_COND_FRNR1;
@IND_COND_FRNR3a = @IND_COND_FRNR1;
@IND_COND_FRNR4 = @IND_COND_FRNR1;
@IND_COND_FRNR5 = @IND_COND_FRNR1;
@IND_COND_BACK2a = @IND_COND_BACK2;
@IND_COND_FRNT2a = @IND_COND_FRNT2;
@IND_COND_FRNR2a = @IND_COND_FRNR2;
#
############ CONDITIONAL TENSES DEFINITE
#
@DEF_COND_BACK1 = ('nám','nád','ná','nánk','nátok','nák','nálak');
@DEF_COND_BACK2 = ('anám','anád','aná','anánk','anátok','anák','análak');
@DEF_COND_BACK1a = @DEF_COND_BACK1;
@DEF_COND_BACK3 = @DEF_COND_BACK1;
@DEF_COND_BACK3a = @DEF_COND_BACK1;
@DEF_COND_BACK3b = @DEF_COND_BACK2;
@DEF_COND_BACK4 = @DEF_COND_BACK1;
@DEF_COND_BACK5 = @DEF_COND_BACK1;
@DEF_COND_FRNT1 = ('ném','néd','né','nénk','nétek','nék','nélek');
@DEF_COND_FRNT2 = ('eném','enéd','ené','enénk','enétek','enék','enélek');
@DEF_COND_FRNT1a = @DEF_COND_FRNT1;
@DEF_COND_FRNT3 = @DEF_COND_FRNT1;
@DEF_COND_FRNT3a = @DEF_COND_FRNT1;
@DEF_COND_FRNT4 = @DEF_COND_FRNT1;
@DEF_COND_FRNT5 = @DEF_COND_FRNT1;
@DEF_COND_FRNR1 = ('ném', 'néd', 'né', 'nénk', 'nétek', 'nék', 'nélek');
@DEF_COND_FRNR2 = ('öném', 'önéd', 'öné', 'önénk', 'önétek', 'önék','önélek');
@DEF_COND_FRNR1a = @DEF_COND_FRNR1;
@DEF_COND_FRNR3 = @DEF_COND_FRNR1;
@DEF_COND_FRNR3a = @DEF_COND_FRNR1;
@DEF_COND_FRNR4 = @DEF_COND_FRNR1;
@DEF_COND_FRNR5 = @DEF_COND_FRNR1;
@DEF_COND_BACK2a = @DEF_COND_BACK2;
@DEF_COND_FRNT2a = @DEF_COND_FRNT2;
@DEF_COND_FRNR2a = @DEF_COND_FRNR2;
#
############ IMPERATIVE TENSES
#
@IND_IMP_BACK = ('jak', 'jál', 'jon', 'junk', 'jatok', 'janak');
@IND_IMP_FRNT = ('jek', 'jél', 'jen', 'jünk', 'jetek', 'jenek');
@IND_IMP_FRNR = ('jek', 'jél', 'jön', 'jünk', 'jetek', 'jenek');

@DEF_IMP_BACK = ('jam', 'jad', 'ja', 'juk', 'játok', 'ják', 'jalak');
@DEF_IMP_FRNT = ('jem', 'jed', 'je', 'jük', 'jétek', 'jék', 'jelek');
@DEF_IMP_FRNR = ('jem', 'jed', 'je', 'jük', 'jétek', 'jék', 'jelek');
#
#
#
$IBACK1="ni"; $IBACK2="ani"; $IBACK3="ni"; $IBACK4="ni"; $IBACK5="ni";
$IBACK1a="ni"; $IBACK2a="ani";
$IBACK3a="ni"; $IBACK3b="ani";
$IFRNT1="ni"; $IFRNT2="eni"; $IFRNT3="ni"; $IFRNT4="ni"; $IFRNT5="ni";
$IFRNT1a="ni"; $IFRNT2a="eni";
$IFRNT3a="ni";
$IFRNR1="ni"; $IFRNR2="eni"; $IFRNR3="ni"; $IFRNR4="ni"; $IFRNR5="ni";
$IFRNR1a="ni"; $IFRNR2a="eni";
$IFRNR3a="ni";

#####  participial endings

$PBACK1="ó"; $PBACK2="ó"; $PBACK3="ó"; $PBACK4="ó"; $PBACK5="ó";
$PBACK1a="ó"; $PBACK2a="ó";
$PBACK3a="ó"; $PBACK3b="ó";
$PFRNT1="ő"; $PFRNT2="ő"; $PFRNT3="ő"; $PFRNT4="ő"; $PFRNT5="ő";
$PFRNT1a="ő"; $PFRNT2a="ő";
$PFRNT3a="ő";
$PFRNR1="ő"; $PFRNR2="ő"; $PFRNR3="ő"; $PFRNR4="ő"; $PFRNR5="ő";
$PFRNR1a="ő"; $PFRNR2a="ő";
$PFRNR3a="ő";

$PPBACK1="ott"; $PPBACK2="ott"; $PPBACK3="ott"; $PPBACK4="ott"; $PPBACK5="ott";
$PPBACK1a="ott"; $PPBACK2a="ott";
$PPBACK3a="ott"; $PPBACK3b="ott";
$PPFRNT1="ett"; $PPFRNT2="ett"; $PPFRNT3="ett"; $PPFRNT4="ett"; $PPFRNT5="ett";
$PPFRNT1a="ett"; $PPFRNT2a="ett";
$PPFRNT3a="ett";
$PPFRNR1="ött"; $PPFRNR2="ött"; $PPFRNR3="ött"; $PPFRNR4="ött"; $PPFRNR5="ött";
$PPFRNR1a="ött"; $PPFRNR2a="ött";
$PPFRNR3a="ött";


@INF_BACK = ('om', 'od', 'ia', 'unk', 'otok', 'iuk');
@INF_FRNT = ('em', 'ed', 'ie', 'ünk', 'etek', 'iük');
@INF_FRNR = ('öm', 'öd', 'ie', 'ünk', 'ötök', 'iük');


# FORMAT 1:VTYPE|2:INFINITIVE|3:PSTEM|4:TRANS=0,INTRANS=1|5:PRES INDEF
#        |6:PRES DEF|7:FUTURE IND|8:FUTURE DEF|9:PAST IND|10:PAST DEF
#        |11:COND IND|12:COND DEF|13:IMP IND|14:IMP DEF
#        |15:PCOND IND|16:CONJ INF|17:pres PARTICIPLE|18:past PARTICIPLE

%IRR = ('van', "BACK1|lenni||1|vagyok:vagy:van:vagyunk:vagytok:vannak||leszek:leszel:lesz:leszünk:lesztek:lesznek||voltam:voltál:volt:voltunk:voltatok:voltak||volnék, lennék:volnál, lennél:volna, lenne:volnánk, lennénk:volnátok, lennétek:volnának, lennének||legyek:legyél, légy:legyen:legyünk:legyetek:legyenek||lettem volna:lettél volna:lett volna:lettünk volna:lettetek volna:lettek volna|lennem:lenned:lennie:lennünk:lennetek:lenniük|való, levő|volt",
	'megy' , "|menni|men|1|megyek:mész:megy:megyünk::||||::ment::||:::::|||||||ment",
	'jön' , "FRNR1|jönni|jöv|1|:jössz:::jöttök:||||jöttem:jöttél:jött:jöttünk:jöttetek:jöttek||||jöjjek:gyere, jöjj, jöjjél:jöjjön:jöjjünk:gyertek, jöjjetek:jöjjenek|||||jött",
	'iszik', "BACK3|inni||0|::::isztok:isznak|::issza:isszuk:isszátok:isszák:iszlak|||ittam:ittál:ivott:ittunk:ittatok:ittak|ittam:ittad:itta:ittuk:ittátok:itták:ittalak|:::::|:::::|igyak:igyál:igyon:igyunk:igyatok:igyanak|igyam:idd, igyad:igya:igyuk:igyátok:igyák:igyalak|||ivó|ivott",
	'eszik', "FRNT3|enni||0|::::esztek:esznek|:::esszük:::eszlek|||ettem:ettél:evett:ettünk:ettetek:ettek|ettem:etted:ette:ettük:ettétek:ették:ettelek|:::::|:::::|egyek:egyél:egyen:együnk:egyetek:egyenek|egyem:edd, egyed:egye:együk:egyétek:egyék:egyelek|||evő|evett",
	'tesz', "FRNT3|tenni||0|::tesz::tesztek:tesznek|:::tesszük:::teszlek|||tettem:tettél:tett:tettünk:tettetek:tettek|tettem:tetted:tette:tettük:tettétek:tették:tettelek|:::::|:::::|tegyek:tegyél:tegyen:tegyünk:tegyetek:tegyenek|tegyem:tedd, tegyed:tegye:tegyük:tegyétek:tegyék:tegyelek|||tevő|tett",
	'vesz', "FRNT3|venni||0|::vesz::vesztek:vesznek|:::vesszük:::veszlek|||vettem:vettél:vett:vettünk:vettetek:vettek|vettem:vetted:vette:vettük:vettétek:vették:vettelek|:::::|:::::|vegyek:vegyél:vegyen:vegyünk:vegyetek:vegyenek|vegyem:vedd, vegyed:vegye:vegyük:vegyétek:vegyék:vegyelek|||vevő|vett",
	'visz', "FRNT3|vinni||0|::visz::visztek:visznek|:::visszük:::viszlek|||vittem:vittél:vitt:vittünk:vittetek:vittek|vittem:vitted:vitte:vittük:vittétek:vitték:vittelek|:::::|:::::|vigyek:vigyél:vigyen:vigyünk:vigyetek:vigyenek|vigyem:vidd, vigyed:vigye:vigyük:vigyétek:vigyék:vigyelek|||vivő|vitt",
	'hisz', "FRNT3|hinni||0|::hisz::hisztek:hisznek|:::hisszük:::hiszlek|||hittem:hittél:hitt:hittünk:hittetek:hittek|hittem:hitted:hitte:hittük:hittétek:hitték:hittelek|:::::|:::::|higgyek:higgyél:higgyen:higgyünk:higgyetek:higgyenek|higgyem:hidd, higgyed:higgye:higgyük:higgyétek:higgyék:higgyelek|||hivő|hitt",
	'lesz', "FRNT3|lenni||1|::lesz::lesztek:lesznek||||lettem:lettél:lett:lettünk:lettetek:lettek||:::::||legyek:legyél, légy:legyen:legyünk:legyetek:legyenek||||levő|lett",
####
####   SZ/D  SZ/Z  SZ/Z/V STEMS
####
	'fekszik', "FRNT3a|feküdni||1|:::::||||:::::|||||",
	'alszik', "BACK3a|aludni||1|::::alusztok:alusznak||||:::::||||||||alvó|aludott",
	'esküszik', "FRNR3a|esküdni||1|:::::||||:::::||||||||esküvő",
	'mosakszik', "BACK3a|mosakodni||0|:::::||||||||||||",
	'öregszik', "FRNT3a|öregedni||0|:::::||||||||||||",
	'emlékszik', "FRNT3a|emlékezni||0|:::::||||:::::|:::::|||",
	'gyülekszik', "FRNT3a|gyülekezni||0|:::::||||:::::|:::::|||",
	'szándékszik', "FRNT3a|szándékezni||0|:::::||||:::::|:::::|||",
	'igyekszik', "FRNT3a|igyekezni||0|:::::||||:::::|:::::|||||||igyekvő",
#####
##### VOWEL DELETING STEMS
#####
# ###   IK ,
	'ugrik', "|ugorni|ugr|1|:ugrasz:::ugrotok:ugranak|||||||",
	'haragszik', "BACK3a|haragudni||0|:::::||||||||||||haragvó|",
	'törekszik', "FRNT3a|torekedni||0|:::::||||||||||||törekvő|",
	'hiányzik', "|hiányozni||0|:::::||||||||||||",
	'lélegzik', "|lélegezni||0|:::::||||:::::|||",
	'melegszik', "|melegedni||0|:::::||||:::::|||",
	'fürdik', "|fürödni|fürd|1|:::::||||:::::|||",
	'romlik', "BACK3b|romlani|roml|0|romlok:romlasz::::|::romolja:romoljuk:romoljátok:romolják:|||:::::||||romoljak:romolj, romoljál:romoljon:romoljunk:romoljatok:romoljanak|romoljam:romold, romoljad:romolja:romoljuk:romoljátok:romolják:romoljalak",
	'oszlik', "|||0|:::::|::oszolja:oszoljuk:oszoljátok:oszolják:|||:::::||||oszoljak:oszolj, oszoljál:oszoljon:oszoljunk:oszoljatok:oszoljanak|oszoljam:oszold, oszoljad:oszolja:oszoljuk:oszoljátok:oszolják:oszoljalak",
	'bomlik', "|||0|:::::|::bomolja:bomoljuk:bomoljátok:bomolják:|||:::::||||bomoljak:bomolj, bomoljál:bomoljon:bomoljunk:bomoljatok:bomoljanak|bomoljam:bomold, bomoljad:bomolja:bomoljuk:bomoljátok:bomolják:bomoljalak",
	'siklik', "BACK2|||0|:::::|::sikolja:sikoljuk:sikoljátok:sikolják:|||:::::||||sikoljak:sikolj, sikoljál:sikoljon:sikoljunk:sikoljatok:sikoljanak|sikoljam:sikold, sikoljad:sikolja:sikoljuk:sikoljátok:sikolják:sikoljalak",
	'ízlik', "|||0|:::::|:::ízeljük:::|||:::::||||ízeljek:ízelj, ízeljél:ízeljen:ízeljünk:ízeljetek:ízeljenek|ízeljem:ízeld, ízeljed:ízelje:ízeljük:ízeljétek:ízeljék:ízeljelek",
	'hangzik', "BACK3|hangozni|hangz|0|:::::|::hangozza:hangozzuk:hangozzátok:hangozzák|||::hangzott:::|||",
# ###    REGULAR
	'becsmérel', "||becsmérl|0|:::::||||||||||",
	'céloz', "||célz|0|:::::||||||||||",
	'didereg', "||diderg|0|:::::||||||||||",
	'dögöl', "||dögl|0|:::::||||||||||",
	'dörög', "||dörg|0|:::::||||||||||",
	'énekel', "||énekl|0|:::::||||||||||",
	'érdemel', "||érdeml|0|:::::||||||||||",
	'érez', "||érz|0|:::::||||||||||",
	'forog', "||forg|0|:::::||||||||||",
	'füstölög', "||füstölg|0|:::::||||||||||",
	'gyakarol', "||gyakarl|0|:::::||||||||||",
	'gyötör', "||gyötr|0|:::::||||||||||",
	'helyesel', "||helyesl|0|:::::||||||||||",
	'hömpölyög', "||hömpölyg|0|:::::||||||||||",
	'hörög', "||hörg|0|:::::||||||||||",
	'igenel', "||igenl|0|:::::||||||||||",
	'igényel', "||igényl|0|:::::||||||||||",
	'ingerel', "||ingerl|0|:::::||||||||||",
	'inog', "||ing|0|:::::||||||||||",
	'irigyel', "||irigyl|0|:::::||||||||||",
	'ismétel', "||ismétl|0|:::::||||||||||",
	'javasol', "||javasl|0|:::::||||||||||",
	'károg', "||kárg|0|:::::|||||||||||||károgott",
	'kesereg', "||keserg|0|:::::||||||||||",
	'kínoz', "||kínz|0|:::::||||||||||",
	'kóborol', "||kóborl|0|:::::||||||||||",
	'könyörög', "||könyörg|0|:::::||||||||||",
	'közöl', "||közl|0|:::::||||||||||",
	'közeleg', "||közelg|1|:::::||||||||||",
	'megjegyez', "||megjegyz|0|:::::||||||||||",
	'mosolyog', "||mosolyg|0|:::::||||||||||",
	'mozog', "||mozg|0|:::::||||||||||",
	'őröl', "||őrl|0|:::::||||||||||",
	'őriz', "FRNR3||őrz|0|:::::||||||||||",
	'pazarol', "||pazarl|0|:::::||||||||||",
	'pezseg', "||pezsg|0|:::::||||||||||",
	'pótol', "||pótl|0|:::::||||||||||",
	'rezeg', "||rezg|0|:::::||||||||||",
	'rabol', "||rabl|0|:::::||||||||||",
	'sajog', "||sajg|0|:::::||||||||||",
	'sebez', "||sebz|0|:::::||||||||||",
	'seper', "||sepr|0|:::::||||||||||",
	'sodor', "||sodr|0|:::::||||||||||",
	'szerez', "||szerz|0|:::::||||||||||",
	'társalog', "||társalg|0|:::::||||||||||",
	'terem', "||term|0|:::::||||||||||",
	'térdepel', "||térdepl|0|:::::||||||||||",
	'tévelyeg', "||tévelyg|0|:::::||||||||||",
	'tipor', "||tipr|0|:::::||||||||||",
	'töröl', "||törl|0|:::::||||||||||",
	'túloz', "||túlz|0|:::::||||||||||",
	'üdvözöl', "||üdvözl|0|||||:::::|||",
	'ünnepel', "||ünnepl|0|:::::||||||||||",
	'végez', "||végz|0|:::::|:::::|||::végzett:::|||",
	'viszonoz', "||viszonz|0|:::::||||||||||",
	'zörög', "||zörg|0|:::::||||||||||",
	'érdekel', "||érdekl|0|:::::||||||||||",
####
#### V ADDING STEMS
####

	'lő', "FRNR1a||löv|0|:::::|||||||||:lődd, lőjed||||",
	'sző', "FRNR1a||szöv|0|:::::|||||||||:sződd, szőjed|",
	'nő', "FRNR1a||növ|0|:::::|||||||||:nődd, nőjed||||nőtt",
	'ró', "BACK1a||rov|0|:::::|||||||||:ródd, rójed|",
	'nyű', "FRNR1a||nyűv|0|:::::|||||||||:nyűdd, nyűjed|",
	'fő', "FRNR1a||főv|0|:::::|||||||||:fődd, főjed||||",
	'rí', "FRNT1a||riv|0|:::::|||||||||:rídd, ríjed|",
####
#### IRREGULAR -LL stems
####
	'hall', "BACK2|||0|:::::|::::::hallak|||:::::|||",
	'hull', "BACK2|||0|:::::|::::::hullak|||:::::|||",
	'kell', "FRNT2|||0|:::::|::::::kellek|||:::::|||",
	'vall', "BACK2|||0|:::::|::::::vallak|||:::::|||",
	'áll', "BACK4|||0|:::::|::::::állak||||",
	'száll', "BACK4|||0|:::::|::::::szállak||||",
####
#### IRREGULAR -AD/-ED stems
####
	'fogad', "BACK1|||0|:::::|:::::|||:::::|||",
	'szenved', "FRNT1|||0|:::::|:::::|||:::::|||",
	'enged', "FRNT1|||0|:::::|:::::|||:::::|||",
	'megragad', "BACK1|||0|:::::|:::::|||:::::|||",
	'tagad', "BACK1|||0|:::::|:::::|||:::::|||",
	'vigad', "BACK1|||0|:::::|:::::|||:::::|||",
	'feled', "FRNT1|||0|:::::|:::::|||:::::|||",
	'senyved', "FRNT1|||0|:::::|:::::|||:::::|||",
	'szenved', "FRNT1|||0|:::::|:::::|||:::::|||",
####
####	IK VERBS THAT MAY USE -ok/-ek
####
	'hazudik', "|||0|hazudok:||||:::::|||||||||",
####
####
####
	'esik', "FRNT3|||0|:::::|||||",
	'edz', "FRNT2|||0|:::::|||||",
	'tetszik', "FRNT2|||1|:::::||||||||tessek:tessél:tessen:tessünk:tessetek:tessenek",
	'bíz', "BACK3|||0|:::::|||||",
	'sír', "BACK2|||0|:::::|||||",
	'sikít', "BACK2|||0|:::::|||||",
	'pirít', "BACK2|||0|:::::|||||",
	'szít', "BACK2|||0|:::::|||||",
	'hív', "BACK1|||0|:::::|||||",
	'játszik', "BACK3b|||0|:::::|||||",
	'nyit', "BACK2|nyitni||0|:nyitsz:::nyittok:nyitnak|::::::nyitlak|||||nyitnék:nyitnál:nyitna:nyitnánk:nyitnátok:nyitnának|nyitnám:nyitnád:nyitná:nyitnánk:nyitnátok:nyitnák:nyitnálak||:nyisd, nyissad",
	'lát', "BACK1|||0|:::::||||||||lássak:láss, lássál:lásson:lássunk:lássatok:lássanak|lássam:lásd, lássad:lássa:lássuk:lássátok:lássák:lássalak",
	'megbocsát', "BACK1|||0|:::::||||||||megbocsássak:megbocsáss, megbocsássál:megbocsásson:megbocsássunk:megbocsássatok:megbocsássanak|megbocsássam:megbocsásd, megbocsássad:megbocsássa:megbocsássuk:megbocsássátok:megbocsássák",
	'ír', "BACK4|||0|:::::|||||");

# b c d f g h j k l m n p r s t v z cs gy ly ny ty sz zs dz dzs
# a á e é i í o ó u ú ö ő ü ű       0  1  2  3  4  5  6  7  8


#  vlsstem = stem without vowel, that vowel initial suffixes are attached to
#  stem = s

# determine default type
$stem = &ortho_encode($verb);
$stem =~ s/ik$//i;
$tstem = $stem;

#if ($IRR{$verb}) {
#    ($junk1,$tstem,$junk2)  = split(/\|/,$IRR{$verb},3);
#    if ($tstem eq "") {
#        $tstem = $stem;
#    } else {
#        $tstem =~ s/[e|a]{0,1}ni$//;
#    }
#}

if (($tstem =~ /[aáoóuú][\w]{0,2}$/) || ($tstem =~ /[aáoóuú]/)) {
    $type = "BACK1";
    if ($tstem =~ /[765sz]$/i) {
        $type = "BACK3";
        if ($tstem =~ /[aáoóuúeéií]s$/) {
            $type = "BACK3a";
        }
    } elsif (($tstem =~ /[rljn23]$/i) || ($tstem =~ /[\w]{2}ad$/i)) {
        $type = "BACK4";
        if ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
            $type = "BACK2";
        }
    } elsif ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
        $type = "BACK2";
        if ($tstem =~ /d$/) {
             $type = "BACK2a";
        }
    } elsif ($tstem =~ /[áóúí]t$/i) {
        $type = "BACK2";
    } elsif ($tstem =~ /^[^áóú]{1,2}t$/i) {
        $type = "BACK5";
    }
} elsif ($tstem =~ /[iíeé][\w]{0,3}$/) {
          $type = "FRNT1";
    if ($tstem =~ /[765sz]$/i) {
            $type = "FRNT3";
        if ($tstem =~ /[eéií]s$/) {
            $type = "FRNT3a";
        }
    } elsif (($tstem =~ /[rljn23]$/i) || ($tstem =~ /[\w]{2}ed$/i)) {
            $type = "FRNT4";
            if ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
                $type = "FRNT2";
            }
    } elsif ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
            $type = "FRNT2";
            if ($tstem =~ /d$/) {
                $type = "FRNT2a";
            }
    } elsif ($tstem =~ /[íé]t$/i) {
            $type = "FRNT2";
    } elsif ($tstem =~ /^[^íé]{1,2}t$/i) {
        $type = "FRNT5";
    }
} elsif ($tstem =~ /[öőüű][\w]{0,3}$/) {
        $type = "FRNR1";
    if ($tstem =~ /[765sz]$/i) {
            $type = "FRNR3";
        if ($tstem =~ /[öőüű]s$/) {
            $type = "FRNR3a";
        }
    } elsif ($tstem =~ /[rljn23]$/i) {
            $type = "FRNR4";
            if ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
                $type = "FRNR2";
            }
    } elsif ($tstem =~ /[bcdfghj-np-tvz0-8]{2}$/i) {
            $type = "FRNR2";
            if ($tstem =~ /d$/) {
                 $type = "FRNR2a";
             }
    } elsif ($tstem =~ /[őű]t$/i) {
          $type = "FRNR2";
    } elsif ($tstem =~ /^[^őű]{1,2}t$/i) {
          $type = "FRNR5";
    }
}

#
# mesh irregularties
#
if ($IRR{$verb}) {
    ($vtype,$inf,$vlsstem,$intrans,$pres_indef,$pres_def,$fut_ind,$fut_def,$past_ind,$past_def,$cond_ind,$cond_def,$imp_ind,$imp_def,$pcond_ind,$conj_inf,$participle,$pparticiple)  = split(/\|/,$IRR{$verb});
    @pres_ind = split(/:/,$pres_indef);
    @pres_def = split(/:/,$pres_def);
    @fut_ind = split(/:/,$fut_ind);
    @fut_def = split(/:/,$fut_def);
    @past_ind = split(/:/,$past_ind);
    @past_def = split(/:/,$past_def);
    @cond_ind = split(/:/,$cond_ind);
    @cond_def = split(/:/,$cond_def);
    @imp_ind = split(/:/,$imp_ind);
    @imp_def = split(/:/,$imp_def);
    @pcond_ind = split(/:/,$pcond_ind);
    @conj_inf = split(/:/,$conj_inf);

    $vtype = $type unless ($vtype);

    if ($vlsstem eq "")  {
        $participle = $stem . ${"P" . $vtype} unless ($participle);
    } else {
        $participle = $vlsstem . ${"P" . $vtype} unless ($participle);
    }

    if ($vlsstem eq "")  {
        $pparticiple = $stem . ${"PP" . $vtype} unless ($pparticiple);
    } else {
        $pparticiple = $vlsstem . ${"PP" . $vtype} unless ($pparticiple);
    }

    $inf = $stem . ${"I" . $vtype} if ($inf eq "");
    $stem2 = $inf;
    $stem2 =~ s/[a|e]{0,1}ni$//;

    $vlsstem = $stem if ($vlsstem eq "");
    $stem = $stem2;

#print "DEBUG: $vlsstem:$stem\n";

    $pres_ind_dec = "IND_PRES_" . $vtype;
    $pres_def_dec = "DEF_PRES_" . $vtype;
    $past_ind_dec = "IND_PAST_" . $vtype;
    $past_def_dec = "DEF_PAST_" . $vtype;
    $cond_ind_dec = "IND_COND_" . $vtype;
    $cond_def_dec = "DEF_COND_" . $vtype;
    $imp_ind_dec = "IND_IMP_" . $vtype; $imp_ind_dec =~ s/\w{1}[a|b]{0,1}$//;
    $imp_def_dec = "DEF_IMP_" . $vtype; $imp_def_dec =~ s/\w{1}[a|b]{0,1}$//;
    $inf_dec = "INF_" . $vtype; $inf_dec =~ s/\w{1}[a|b]{0,1}$//;
    $inf_stem = $inf; $inf_stem =~ s/i$//;

    for ($i=0;$i<7;$i++) {
        $conj_inf[$i] = $inf_stem . ${$inf_dec}[$i] unless ($conj_inf[$i]);

	if (($verb =~ /ik$/i) && ($i == 2)) {
            $pres_ind[$i] = $verb unless ($pres_ind[$i]);
	} else {
            if (($vlsstem ne "") && (${$pres_ind_dec}[$i] =~ /^[a|e|o|i|u|á|é|ö|ü]{1}/i)) {
                $pres_ind[$i] = $vlsstem . ${$pres_ind_dec}[$i] unless ($pres_ind[$i]);
            } else {
                $pres_ind[$i] = $stem . ${$pres_ind_dec}[$i] unless ($pres_ind[$i]);
            }
        }
	if (($i == 0) && ($verb =~ /ik$/)) {
	        $pres_ind[$i] =~ s/k$/m/;
	}

        if ($fut_ind[$i]) {
	    $future_ind[$i] = $fut_ind[$i];
	    $future_def[$i] = $fut_def[$i];
        } else {
	    $future_ind[$i] = @IND_FUTURE[$i] . " " . $inf;
	    $future_def[$i] = @DEF_FUTURE[$i] . " " . $inf;
        }

        if (($vlsstem ne "") && (${$past_ind_dec}[$i] =~ /^[a|e|o|i|u|á|é|ö|ü]{1}/i)) {
		$past_ind[$i] = $vlsstem . ${$past_ind_dec}[$i] unless ($past_ind[$i]);
	} else {
		$past_ind[$i] = $stem2 . ${$past_ind_dec}[$i] unless ($past_ind[$i]);
        }
	$past_def[$i] = $stem2 . ${$past_def_dec}[$i] unless ($past_def[$i]);

	$cond_ind[$i] = $stem2 . ${$cond_ind_dec}[$i] unless ($cond_ind[$i]);
	$cond_def[$i] = $stem2 . ${$cond_def_dec}[$i] unless ($cond_def[$i]);

	$pcond_ind[$i] = $past_ind[$i] . " volna" unless ($pcond_ind[$i]);
	$pcond_def[$i] = $past_def[$i] . " volna" unless ($pcond_def[$i]);

	if ($stem2 =~ /[5|6|7|s|z]$/) {
	    if ($i==1) {
                if (!$imp_ind[$i]) {
		    $imp_ind[$i] = &ortho_morph_szj($stem2,${$imp_ind_dec}[$i]); 
                    $imp_ind[$i] = &ortho_morph_szj($stem2,"j") . ", " . $imp_ind[$i]; 
                }
                if (!$imp_def[$i]) {
                    $imp_def[$i] = &ortho_morph_szj($stem2,${$imp_def_dec}[$i]); 
                    $imp_def[$i] = &ortho_morph_szj($stem2,"d") . ", " . $imp_def[$i];
                }
            }
            $imp_ind[$i] = &ortho_morph_szj($stem2,${$imp_ind_dec}[$i]) unless ($imp_ind[$i]); 
            $imp_def[$i] = &ortho_morph_szj($stem2,${$imp_def_dec}[$i]) unless ($imp_def[$i]); 
        } elsif ($stem2 =~ /[5|6|s]t$/) {
	    if ($i==1) {
                if (!$imp_ind[$i]) {
		    $imp_ind[$i] = &ortho_morph_sztj($stem2,${$imp_ind_dec}[$i]); 
                    $imp_ind[$i] = &ortho_morph_sztj($stem2,"j") . ", " . $imp_ind[$i]; 
                }
                if (!$imp_def[$i]) {
                    $imp_def[$i] = &ortho_morph_sztj($stem2,${$imp_def_dec}[$i]); 
                    $imp_def[$i] = &ortho_morph_sztj($stem2,"d") . ", " . $imp_def[$i];
                }
            }
            $imp_ind[$i] = &ortho_morph_sztj($stem2,${$imp_ind_dec}[$i]) unless ($imp_ind[$i]); 
            $imp_def[$i] = &ortho_morph_sztj($stem2,${$imp_def_dec}[$i]) unless ($imp_def[$i]); 
        } elsif ($stem2 =~ /[a|e|i|o|u|ö|ü]t$/) {
	    if ($i==1) {
                if (!$imp_ind[$i]) {
		    $imp_ind[$i] = &ortho_morph_shortt($stem2,${$imp_ind_dec}[$i]); 
                    $imp_ind[$i] = &ortho_morph_shortt($stem2,"j") . ", " . $imp_ind[$i]; 
                }
                if (!$imp_def[$i]) {
                    $imp_def[$i] = &ortho_morph_shorttd($stem2,${$imp_def_dec}[$i]); 
                    $imp_def[$i] = &ortho_morph_shorttd($stem2,"d") . ", " . $imp_def[$i];
                }
            }
            $imp_ind[$i] = &ortho_morph_shortt($stem2,${$imp_ind_dec}[$i]) unless ($imp_ind[$i]); 
            $imp_def[$i] = &ortho_morph_shortt($stem2,${$imp_def_dec}[$i]) unless ($imp_def[$i]); 
        } elsif ($stem2 =~ /[á|é|í|ó|ú|ő|ű|b|c|d|f|g|h|j|k|l|m|n|p|r|t|v|z|0|1|2|3|4|6|7|8]t$/) {
	    if ($i==1) {
                if (!$imp_ind[$i]) {
		    $imp_ind[$i] = &ortho_morph_longt($stem2,${$imp_ind_dec}[$i]); 
                    $imp_ind[$i] = &ortho_morph_longt($stem2,"j") . ", " . $imp_ind[$i]; 
                }
                if (!$imp_def[$i]) {
                    $imp_def[$i] = &ortho_morph_longt($stem2,${$imp_def_dec}[$i]); 
                    $imp_def[$i] = &ortho_morph_longt($stem2,"d") . ", " . $imp_def[$i];
                }
            }
            $imp_ind[$i] = &ortho_morph_longt($stem2,${$imp_ind_dec}[$i]) unless ($imp_ind[$i]); 
            $imp_def[$i] = &ortho_morph_longt($stem2,${$imp_def_dec}[$i]) unless ($imp_def[$i]); 
        } else {
	    if ($i == 1) {
	        if (!$imp_ind[$i]) {
                    $imp_ind[$i] = $stem2."j"; 
                    $imp_ind[$i] .= ", ".$stem2.${$imp_ind_dec}[$i]; 
                }
	        if (!$imp_def[$i]) {
                    $imp_def[$i] = $stem2."d"; 
                    $imp_def[$i] .= ", ".$stem2.${$imp_def_dec}[$i]; 
                }
            } else {
                $imp_ind[$i] = $stem2.${$imp_ind_dec}[$i] unless ($imp_ind[$i]); 
                $imp_def[$i] = $stem2.${$imp_def_dec}[$i] unless ($imp_def[$i]); 
            }
        }
	if ($intrans == 1) {
            $pres_def[$i] = "NA";
	    $future_def[$i] = "NA";
	    $past_def[$i] = "NA";
	    $cond_def[$i] = "NA";
	    $pcond_def[$i] = "NA";
	    $imp_def[$i] = "NA";
        } elsif (($stem =~ /[5|7|s|z|6]$/) && (${$pres_def_dec}[$i] =~ /^j/)) { 
            $pres_def[$i] = &ortho_morph_szj($stem,${$pres_def_dec}[$i]) unless ($pres_def[$i]); 
        } else {
            if (($vlsstem ne "") && (${$pres_def_dec}[$i] =~ /^[a|e|o|i|u|á|é|ö|ü]{1}/i)) {
                $pres_def[$i] = $vlsstem . ${$pres_def_dec}[$i] unless ($pres_def[$i]);
            } else {
                $pres_def[$i] = $stem . ${$pres_def_dec}[$i] unless ($pres_def[$i]);
            }
        }
    }

#
# if no irregularities, generate regular tables
#
} else {
    $pres_ind_dec = "IND_PRES_" . $type;
    $pres_def_dec = "DEF_PRES_" . $type;
    $past_ind_dec = "IND_PAST_" . $type;
    $past_def_dec = "DEF_PAST_" . $type;
    $cond_ind_dec = "IND_COND_" . $type;
    $cond_def_dec = "DEF_COND_" . $type;
    $imp_ind_dec = "IND_IMP_" . $type; $imp_ind_dec =~ s/\w{1}[a]{0,1}$//;
    $imp_def_dec = "DEF_IMP_" . $type; $imp_def_dec =~ s/\w{1}[a]{0,1}$//;

    $inf = $stem . ${"I" . $type};

    if ($vlsstem eq "")  {
        $participle = $stem . ${"P" . $type};
    } else {
        $participle = $vlsstem . ${"P" . $type};
    }

    if ($vlsstem eq "")  {
        $pparticiple = $stem . ${"PP" . $type};
    } else {
        $pparticiple = $vlsstem . ${"PP" . $type};
    }

    $inf_dec = "INF_" . $type; $inf_dec =~ s/\w{1}[a]{0,1}$//;
    $inf_stem = $inf; $inf_stem =~ s/i$//;

    for ($i=0;$i<7;$i++) {
        $conj_inf[$i] = $inf_stem . ${$inf_dec}[$i];
        $pres_ind[$i] = $stem . ${$pres_ind_dec}[$i];
	if (($verb =~ /ik$/i) && ($i == 2)) {
            $pres_ind[$i] = $verb;
	}
	if (($i == 0) && ($verb =~ /ik$/)) {
	    $pres_ind[$i] =~ s/k$/m/;
	}
        if (($stem =~ /[5|7|s|z|6]$/) && (${$pres_def_dec}[$i] =~ /^j/)) { 
            $pres_def[$i] = &ortho_morph_szj($stem,${$pres_def_dec}[$i]); 
        } else {
            $pres_def[$i] = $stem . ${$pres_def_dec}[$i];
        }

	$future_ind[$i] = @IND_FUTURE[$i] . " " . $inf;
	$future_def[$i] = @DEF_FUTURE[$i] . " " . $inf;

	$past_ind[$i] = $stem . ${$past_ind_dec}[$i];
	$past_def[$i] = $stem . ${$past_def_dec}[$i];

	$cond_ind[$i] = $stem . ${$cond_ind_dec}[$i];
	$cond_def[$i] = $stem . ${$cond_def_dec}[$i];

	$pcond_ind[$i] = $past_ind[$i] . " volna";
	$pcond_def[$i] = $past_def[$i] . " volna";

	if ($stem =~ /[5|7|s|z|6]$/) {
            $imp_ind[$i] = &ortho_morph_szj($stem,${$imp_ind_dec}[$i]); 
            $imp_def[$i] = &ortho_morph_szj($stem,${$imp_def_dec}[$i]); 
	    if ($i==1) {
             $imp_ind[$i] = &ortho_morph_szj($stem,"j") . ", " . $imp_ind[$i]; 
             $imp_def[$i] = &ortho_morph_szj($stem,"d") . ", " . $imp_def[$i]; 
            }
        } elsif ($stem =~ /[5|s]t$/) {
            $imp_ind[$i] = &ortho_morph_sztj($stem,${$imp_ind_dec}[$i]); 
            $imp_def[$i] = &ortho_morph_sztj($stem,${$imp_def_dec}[$i]); 
	    if ($i==1) {
             $imp_ind[$i] = &ortho_morph_sztj($stem,"j") . ", " . $imp_ind[$i]; 
             $imp_def[$i] = &ortho_morph_sztj($stem,"d") . ", " . $imp_def[$i]; 
            }
        } elsif ($stem =~ /[a|e|i|o|u|ö|ü]t$/) {
            $imp_ind[$i] = &ortho_morph_shortt($stem,${$imp_ind_dec}[$i]); 
            $imp_def[$i] = &ortho_morph_shortt($stem,${$imp_def_dec}[$i]); 
	    if ($i==1) {
             $imp_ind[$i] = &ortho_morph_shortt($stem,"j") . ", " . $imp_ind[$i]; 
             $imp_def[$i] = &ortho_morph_shorttd($stem,"d") . ", " . $imp_def[$i]; 
            }
        } elsif ($stem =~ /[á|é|í|ó|ú|ő|ű|b|c|d|f|g|h|j|k|l|m|n|p|r|t|v|z|0|1|2|3|4|6|7|8]t$/) {
            $imp_ind[$i] = &ortho_morph_longt($stem,${$imp_ind_dec}[$i]); 
            $imp_def[$i] = &ortho_morph_longt($stem,${$imp_def_dec}[$i]); 
	    if ($i==1) {
             $imp_ind[$i] = &ortho_morph_longt($stem,"j") . ", " . $imp_ind[$i]; 
             $imp_def[$i] = &ortho_morph_longt($stem,"jd") . ", " . $imp_def[$i]; 
            }
        } else {
	    $imp_ind[$i] = $stem . ${$imp_ind_dec}[$i];
	    $imp_def[$i] = $stem . ${$imp_def_dec}[$i];
	    if ($i==1) {
             $imp_ind[$i] = $stem."j" . ", " . $imp_ind[$i]; 
             $imp_def[$i] = $stem."d" . ", " . $imp_def[$i]; 
            }
        }
    }
}
#
# print all
#

# make pastparticiple same as 3rd sing indef past
$pparticiple = $past_ind[2];

#$out[0] .= "$type/$vtype:   $particle$stem-   $particle$vlsstem-\n";
#$out[1] .= &ortho_decode($inf). ":" . &ortho_decode($participle) . ":" . &ortho_decode($pparticiple)."\n";

$infinitive = &ortho_decode($inf);
$participle = &ortho_decode($participle);
$pparticiple = &ortho_decode($pparticiple);

for ($i=0;$i<7;$i++) {
  $out[$i] .= &ortho_decode($particle.$pres_ind[$i]) . ":";
   if ($pres_def[$i] eq "NA") {
        $out[$i] .= &ortho_decode($pres_def[$i]) . ":";
   } else {
        $out[$i] .= &ortho_decode($particle.$pres_def[$i]) . ":";
    }
   $out[$i] .= &ortho_decode($particle." ".$future_ind[$i]) . ":";
    if ($future_def[$i] eq "NA") {
        $out[$i] .=  &ortho_decode($future_def[$i]) . ":";
    } else {
         $out[$i] .=  &ortho_decode($particle." ".$future_def[$i]) . ":";
    }
     $out[$i] .= &ortho_decode($particle.$past_ind[$i]) . ":";
    if ($past_def[$i] eq "NA") {
         $out[$i] .=  &ortho_decode($past_def[$i]) . ":";
    } else {
         $out[$i] .=  &ortho_decode($particle.$past_def[$i]) . ":";
    }
     $out[$i] .= &ortho_decode($particle.$cond_ind[$i]) . ":";
    if ($cond_def[$i] eq "NA") {
         $out[$i] .=  &ortho_decode($cond_def[$i]) . ":";
    } else {
         $out[$i] .=  &ortho_decode($particle.$cond_def[$i]) . ":";
    }
     $out[$i] .=  &ortho_decode($particle.$pcond_ind[$i]) . ":";
    if ($cond_def[$i] eq "NA") {
         $out[$i] .=  &ortho_decode($pcond_def[$i]) . ":";
    } else {
       $out[$i] .= &ortho_decode($particle.$pcond_def[$i]) . ":";
    }
    $impind = &ortho_decode($imp_ind[$i]);
    if ($impind =~ /,/) {
        $impind =~ s/^([^,| ]*), ([^,| ]*)$/$particle$1, $particle$2/;
        $impind =~ s/^([^,| ]*), ([^,| ]*), ([^,| ]*)$/$particle$1, $particle$2, $particle$3/;
         $out[$i] .= $impind . ":";
    } else {
         $out[$i] .=  $particle.$impind . ":";
    }

    $impdef = &ortho_decode($imp_def[$i]);

    if ($imp_def[$i] eq "NA") {
        $particle_id = "";
    } else {
        $particle_id = $particle;
    }
    if ($impdef =~ /,/) {
        $impdef =~ s/^([^,| ]*), ([^,| ]*)$/$particle_id$1, $particle_id$2/;
         $out[$i] .= $impdef . ":";
    } else {
         $out[$i] .= $particle_id.$impdef . ":";
    }
     $out[$i] .= &ortho_decode($particle.$conj_inf[$i]) . ":";
     $out[$i] .= "\n";
}

sub ortho_morph_szj {
    local ($tempstem,$tempdec) = @_;
    if ($tempdec =~ /^j/) {
        $tempdec =~ s/^j//;
        $tempstem =~ s/z$/zz/; 
        $tempstem =~ s/5$/s5/;
        $tempstem =~ s/s$/ss/; 
        $tempstem =~ s/6$/z6/;
        $tempstem =~ s/7$/d7/; 
    }
    return($tempstem . $tempdec);
}
sub ortho_morph_sztj {
    local ($tempstem,$tempdec) = @_;
    if ($tempdec =~ /^j/) {
        $tempdec =~ s/^j//;
        $tempstem =~ s/5t$/s5/; 
        $tempstem =~ s/st$/ss/; 
    } else {
        $tempstem =~ s/t$//; 
        $tempstem =~ s/t$//; 
    }
    return($tempstem . $tempdec);
}
sub ortho_morph_shortt {
    local ($tempstem,$tempdec) = @_;
    $tempdec =~ s/^j//;
    $tempstem =~ s/t$/ss/; 
    return($tempstem . $tempdec);
}
sub ortho_morph_shorttd {
    local ($tempstem,$tempdec) = @_;
    $tempdec =~ s/^j//;
    $tempstem =~ s/t$/s/; 
    return($tempstem . $tempdec);
}
sub ortho_morph_longt {
    local ($tempstem,$tempdec) = @_;
    $tempdec =~ s/^j/s/;
    return($tempstem . $tempdec);
}

sub ortho_encode {
    local ($string) = $_[0];
    $string =~ s/cs/0/g;
    $string =~ s/gy/1/g;
    $string =~ s/ly/2/g;
    $string =~ s/ny/3/g;
    $string =~ s/ty/4/g;
    $string =~ s/sz/5/g;
    $string =~ s/zs/6/g;
    $string =~ s/dz/7/g;
    $string =~ s/dzs/8/g;
    return($string);
}
sub ortho_decode {
    local ($string) = $_[0];
    $string =~ s/0/cs/g;
    $string =~ s/1/gy/g;
    $string =~ s/2/ly/g;
    $string =~ s/3/ny/g;
    $string =~ s/4/ty/g;
    $string =~ s/5/sz/g;
    $string =~ s/6/zs/g;
    $string =~ s/7/dz/g;
    $string =~ s/8/dzs/g;
    return($string);
}
##########
########## end old hvc2.pl code

#    $controll = shift (@out);
#   $infpart = shift (@out);
#    ($infinitive,$participle,$pparticiple) = split (/:/,$infpart);
 
    $ii = 0;
    foreach (@out) { 
        @line = split (/:/,$_);
	push (@pres_ind2,$line[0]) unless ($ii == 6);
	push (@pres_def2,$line[1]);
	push (@future_ind2,$line[2]) unless ($ii == 6);
	push (@future_def2,$line[3]);
	push (@past_ind2,$line[4]) unless ($ii == 6);
	push (@past_def2,$line[5]);
	push (@cond_ind2,$line[6]) unless ($ii == 6);
	push (@cond_def2,$line[7]);
	push (@pcond_ind2,$line[8]) unless ($ii == 6);
	push (@pcond_def2,$line[9]);
	push (@imp_ind2,$line[10]) unless ($ii == 6);
	push (@imp_def2,$line[11]);
	push (@conj_inf2,$line[12]) unless ($ii == 6);
      $ii++;
    }
#    print "<P>\n";
#    print "$controll\n"; 
    print "<P>\n";
    print "<CENTER>\n";
    print "<TABLE BORDER=0 CELLPADDING=3>\n";
    print "  <TR>\n";
    print "    <TD BGCOLOR=#AAAAAA COLSPAN=2>\n";
    print "      <TABLE BORDER=0>\n";
    print "        <TR>\n";
    print "          <TD ALIGN=RIGHT><FONT SIZE=-1>INFINITIVE:</FONT></TD><TD><FONT SIZE=-1>$particle$infinitive</FONT></TD>\n";
    print "        </TR>\n";
    print "        <TR>\n";
    print "          <TD ALIGN=RIGHT><FONT SIZE=-1>PRESENT PARTICIPLE:</FONT></TD><TD><FONT SIZE=-1>$particle$participle</FONT></TD>\n";
    print "        </TR>\n";
    print "        <TR>\n";
    print "          <TD ALIGN=RIGHT><FONT SIZE=-1>PAST PARTICIPLE:</FONT></TD><TD><FONT SIZE=-1>$particle$pparticiple</FONT></TD>\n";
    print "        </TR>\n";
    print "      </TABLE>\n";
    print "    </B></FONT>\n";
    print "    </TD>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TH BGCOLOR=#FF0000 COLSPAN=2>\n";
    print "    <BIG>I</BIG>NDICATIVE<BR>\n";
    print "    </TH>\n";
    print "    <TD ROWSPAN=20 VALIGN=top>
    <script type=\"text/javascript\"><!--
google_ad_client = \"pub-5668749994244431\";
/* HVC, tall right */
google_ad_slot = \"5637948009\";
google_ad_width = 160;
google_ad_height = 600;
//-->
</script>
<script type=\"text/javascript\"
src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\">
</script>
";
    print "  </TD>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3><BIG>P</BIG>RESENT</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "pres_ind2","pres_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3><BIG>P</BIG>AST</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "past_ind2","past_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TD></TD>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3><BIG>F</BIG>UTURE</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "future_ind2","future_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    }
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TH BGCOLOR=#00CC00 COLSPAN=2>\n";
    print "    <BIG>C</BIG>ONDITIONAL<BR>\n";
    print "    </TH>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3><BIG>P</BIG>RESENT</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "cond_ind2", "cond_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3><BIG>P</BIG>AST</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "pcond_ind2", "pcond_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TH BGCOLOR=#AAAAAA COLSPAN=1>\n";
    print "    <BIG>C</BIG>ONJUNCTIVE/<BIG>I</BIG>MPERATIVE<BR>\n";
    print "    </TH>\n";
    print "    <TH BGCOLOR=#AAAAAA COLSPAN=1>\n";
    print "    <BIG>C</BIG>ONJUGATED <BIG>I</BIG>NFINITIVE<BR>\n";
    print "    </TH>\n";
    print "  </TR>\n";
    print "  <TR>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3>&nbsp;<TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    print "         <TD></TD>\n";
    print "         <TH><FONT SIZE=-1>indefinite</TH>\n";
    print "         <TH><FONT SIZE=-1>definite</TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "imp_ind2", "imp_def2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 5) {
                print "      $i<P>\n" if ($i);
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "    <TD>\n";
    print "    <TABLE BORDER=0 CELLPADDING=3>\n";
    print "      <TR>\n";
    print "         <TH COLSPAN=3>&nbsp;<TH>\n";
    print "      </TR>\n";
    print "      <TR>\n";
    foreach ("TENSEDEF", "conj_inf2") {
        $ccc = 0;
        print "    <TD VALIGN=TOP><FONT SIZE=-1>\n";
	foreach $i (@{$_}) {
            if ($ccc == 6) {
                end;
            } else {
                print "      $i<BR>\n" if ($i);
            } 
            $ccc++;
        }
        print "    </FONT></TD>\n";
    } 
    print "      </TR>\n";
    print "    </TABLE>\n";
    print "    </TD>\n";
    print "  </TR>\n";
    print "</TABLE>\n";
    print "</CENTER>\n";
    print "\n";
    print "<P>\n";
    print "<CENTER>\n";
print "<table width=300px>
<tr><td align=center>
<a rel=\"license\" href=\"http://creativecommons.org/licenses/by/4.0/\"><img alt=\"Creative Commons License\" style=\"border-width:0\" src=\"http://i.creativecommons.org/l/by/4.0/88x31.png\" /></a><br /><span xmlns:dct=\"http://purl.org/dc/terms/\" property=\"dct:title\">Hungarian Verb Conjugator</span> by <a xmlns:cc=\"http://creativecommons.org/ns#\" href=\"http://www.jargot.com/hvc\" property=\"cc:attributionName\" rel=\"cc:attributionURL\">Tim Talpas</a> is licensed under a <a rel=\"license\" href=\"http://creativecommons.org/licenses/by/4.0/\">Creative Commons Attribution 4.0 International License</a>.
</td></tr>
<tr><td align=center> &nbsp;
</td></tr>
<tr><td align=center>
<font size=-1>
<p></p>
<i>updated 05-07-12</i> <br />
<a href=\"mailto:magyar@jargot.com\">magyar@jargot.com</a>
</font>
</td></tr>
</table>
</center>";

    print "</BODY></HTML>\n";

}
sub char_trans {
    local ($string) = $_[0];
    $string =~ s/a\//á/g;       # a' -> á a acute
    $string =~ s/e\//é/g;       # e' -> é t acute
    $string =~ s/i\//í/g;       # i' -> í a acute
    $string =~ s/o\/\//ő/g;       # o" -> ő o double acute
    $string =~ s/u\/\//ű/g;       # u" -> ű u double acute
    $string =~ s/o\//ó/g;       # o' -> ó i acute
    $string =~ s/u\//ú/g;       # u' -> ú a acute
    $string =~ s/o:/ö/g;       # o: -> ö o umlat
    $string =~ s/u:/ü/g;       # u: -> ü u umlat
    return ($string);
}

