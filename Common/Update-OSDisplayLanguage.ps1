function Update-OSDisplayLanguage {
    <#
    .SYNOPSIS
    Update systerm disply language 
    
    .DESCRIPTION
        LCID             Name             DisplayName                                                                                              
        ----             ----             -----------                                                                                              
        127                               Invariant Language (Invariant Country)                                                                   
        54               af               Afrikaans                                                                                                
        1078             af-ZA            Afrikaans (South Africa)                                                                                 
        94               am               Amharic                                                                                                  
        1118             am-ET            Amharic (Ethiopia)                                                                                       
        1                ar               Arabic                                                                                                   
        14337            ar-AE            Arabic (U.A.E.)                                                                                          
        15361            ar-BH            Arabic (Bahrain)                                                                                         
        5121             ar-DZ            Arabic (Algeria)                                                                                         
        3073             ar-EG            Arabic (Egypt)                                                                                           
        2049             ar-IQ            Arabic (Iraq)                                                                                            
        11265            ar-JO            Arabic (Jordan)                                                                                          
        13313            ar-KW            Arabic (Kuwait)                                                                                          
        12289            ar-LB            Arabic (Lebanon)                                                                                         
        4097             ar-LY            Arabic (Libya)                                                                                           
        6145             ar-MA            Arabic (Morocco)                                                                                         
        8193             ar-OM            Arabic (Oman)                                                                                            
        16385            ar-QA            Arabic (Qatar)                                                                                           
        1025             ar-SA            Arabic (Saudi Arabia)                                                                                    
        10241            ar-SY            Arabic (Syria)                                                                                           
        7169             ar-TN            Arabic (Tunisia)                                                                                         
        9217             ar-YE            Arabic (Yemen)                                                                                           
        122              arn              Mapudungun                                                                                               
        1146             arn-CL           Mapudungun (Chile)                                                                                       
        77               as               Assamese                                                                                                 
        1101             as-IN            Assamese (India)                                                                                         
        44               az               Azerbaijani                                                                                              
        29740            az-Cyrl          Azerbaijani (Cyrillic)                                                                                   
        2092             az-Cyrl-AZ       Azerbaijani (Cyrillic, Azerbaijan)                                                                       
        30764            az-Latn          Azerbaijani (Latin)                                                                                      
        1068             az-Latn-AZ       Azerbaijani (Latin, Azerbaijan)                                                                          
        109              ba               Bashkir                                                                                                  
        1133             ba-RU            Bashkir (Russia)                                                                                         
        35               be               Belarusian                                                                                               
        1059             be-BY            Belarusian (Belarus)                                                                                     
        2                bg               Bulgarian                                                                                                
        1026             bg-BG            Bulgarian (Bulgaria)                                                                                     
        102              bin              Edo                                                                                                      
        1126             bin-NG           Edo (Nigeria)                                                                                            
        69               bn               Bangla                                                                                                   
        2117             bn-BD            Bangla (Bangladesh)                                                                                      
        1093             bn-IN            Bangla (India)                                                                                           
        81               bo               Tibetan                                                                                                  
        1105             bo-CN            Tibetan (PRC)                                                                                            
        126              br               Breton                                                                                                   
        1150             br-FR            Breton (France)                                                                                          
        30746            bs               Bosnian                                                                                                  
        25626            bs-Cyrl          Bosnian (Cyrillic)                                                                                       
        8218             bs-Cyrl-BA       Bosnian (Cyrillic, Bosnia and Herzegovina)                                                               
        26650            bs-Latn          Bosnian (Latin)                                                                                          
        5146             bs-Latn-BA       Bosnian (Latin, Bosnia and Herzegovina)                                                                  
        3                ca               Catalan                                                                                                  
        1027             ca-ES            Catalan (Catalan)                                                                                        
        2051             ca-ES-valencia   Valencian (Spain)                                                                                        
        92               chr              Cherokee                                                                                                 
        31836            chr-Cher         Cherokee (Cherokee)                                                                                      
        1116             chr-Cher-US      Cherokee (Cherokee)                                                                                      
        131              co               Corsican                                                                                                 
        1155             co-FR            Corsican (France)                                                                                        
        5                cs               Czech                                                                                                    
        1029             cs-CZ            Czech (Czech Republic)                                                                                   
        82               cy               Welsh                                                                                                    
        1106             cy-GB            Welsh (United Kingdom)                                                                                   
        6                da               Danish                                                                                                   
        1030             da-DK            Danish (Denmark)                                                                                         
        7                de               German                                                                                                   
        3079             de-AT            German (Austria)                                                                                         
        2055             de-CH            German (Switzerland)                                                                                     
        1031             de-DE            German (Germany)                                                                                         
        5127             de-LI            German (Liechtenstein)                                                                                   
        4103             de-LU            German (Luxembourg)                                                                                      
        31790            dsb              Lower Sorbian                                                                                            
        2094             dsb-DE           Lower Sorbian (Germany)                                                                                  
        101              dv               Divehi                                                                                                   
        1125             dv-MV            Divehi (Maldives)                                                                                        
        3153             dz-BT            Dzongkha (Bhutan)                                                                                        
        8                el               Greek                                                                                                    
        1032             el-GR            Greek (Greece)                                                                                           
        9                en               English                                                                                                  
        9225             en-029           English (Caribbean)                                                                                      
        3081             en-AU            English (Australia)                                                                                      
        10249            en-BZ            English (Belize)                                                                                         
        4105             en-CA            English (Canada)                                                                                         
        2057             en-GB            English (United Kingdom)                                                                                 
        15369            en-HK            English (Hong Kong SAR)                                                                                  
        14345            en-ID            English (Indonesia)                                                                                      
        6153             en-IE            English (Ireland)                                                                                        
        16393            en-IN            English (India)                                                                                          
        8201             en-JM            English (Jamaica)                                                                                        
        17417            en-MY            English (Malaysia)                                                                                       
        5129             en-NZ            English (New Zealand)                                                                                    
        13321            en-PH            English (Republic of the Philippines)                                                                    
        18441            en-SG            English (Singapore)                                                                                      
        11273            en-TT            English (Trinidad and Tobago)                                                                            
        1033             en-US            English (United States)                                                                                  
        7177             en-ZA            English (South Africa)                                                                                   
        12297            en-ZW            English (Zimbabwe)                                                                                       
        10               es               Spanish                                                                                                  
        22538            es-419           Spanish (Latin America)                                                                                  
        11274            es-AR            Spanish (Argentina)                                                                                      
        16394            es-BO            Spanish (Bolivia)                                                                                        
        13322            es-CL            Spanish (Chile)                                                                                          
        9226             es-CO            Spanish (Colombia)                                                                                       
        5130             es-CR            Spanish (Costa Rica)                                                                                     
        23562            es-CU            Spanish (Cuba)                                                                                           
        7178             es-DO            Spanish (Dominican Republic)                                                                             
        12298            es-EC            Spanish (Ecuador)                                                                                        
        3082             es-ES            Spanish (Spain)                                                                                          
        4106             es-GT            Spanish (Guatemala)                                                                                      
        18442            es-HN            Spanish (Honduras)                                                                                       
        2058             es-MX            Spanish (Mexico)                                                                                         
        19466            es-NI            Spanish (Nicaragua)                                                                                      
        6154             es-PA            Spanish (Panama)                                                                                         
        10250            es-PE            Spanish (Peru)                                                                                           
        20490            es-PR            Spanish (Puerto Rico)                                                                                    
        15370            es-PY            Spanish (Paraguay)                                                                                       
        17418            es-SV            Spanish (El Salvador)                                                                                    
        21514            es-US            Spanish (United States)                                                                                  
        14346            es-UY            Spanish (Uruguay)                                                                                        
        8202             es-VE            Spanish (Bolivarian Republic of Venezuela)                                                               
        37               et               Estonian                                                                                                 
        1061             et-EE            Estonian (Estonia)                                                                                       
        45               eu               Basque                                                                                                   
        1069             eu-ES            Basque (Basque)                                                                                          
        41               fa               Persian                                                                                                  
        1065             fa-IR            Persian (Iran)                                                                                           
        103              ff               Fulah                                                                                                    
        31847            ff-Latn          Fulah (Latin)                                                                                            
        2151             ff-Latn-SN       Fulah (Latin, Senegal)                                                                                   
        1127             ff-NG            Fulah (Nigeria)                                                                                          
        11               fi               Finnish                                                                                                  
        1035             fi-FI            Finnish (Finland)                                                                                        
        100              fil              Filipino                                                                                                 
        1124             fil-PH           Filipino (Philippines)                                                                                   
        56               fo               Faroese                                                                                                  
        1080             fo-FO            Faroese (Faroe Islands)                                                                                  
        12               fr               French                                                                                                   
        7180             fr-029           French (Caribbean)                                                                                       
        2060             fr-BE            French (Belgium)                                                                                         
        3084             fr-CA            French (Canada)                                                                                          
        9228             fr-CD            French (Congo DRC)                                                                                       
        4108             fr-CH            French (Switzerland)                                                                                     
        12300            fr-CI            French (Côte d’Ivoire)                                                                                   
        11276            fr-CM            French (Cameroon)                                                                                        
        1036             fr-FR            French (France)                                                                                          
        15372            fr-HT            French (Haiti)                                                                                           
        5132             fr-LU            French (Luxembourg)                                                                                      
        14348            fr-MA            French (Morocco)                                                                                         
        6156             fr-MC            French (Monaco)                                                                                          
        13324            fr-ML            French (Mali)                                                                                            
        8204             fr-RE            French (Reunion)                                                                                         
        10252            fr-SN            French (Senegal)                                                                                         
        98               fy               Frisian                                                                                                  
        1122             fy-NL            Frisian (Netherlands)                                                                                    
        60               ga               Irish                                                                                                    
        2108             ga-IE            Irish (Ireland)                                                                                          
        145              gd               Scottish Gaelic                                                                                          
        1169             gd-GB            Scottish Gaelic (United Kingdom)                                                                         
        86               gl               Galician                                                                                                 
        1110             gl-ES            Galician (Galician)                                                                                      
        116              gn               Guarani                                                                                                  
        1140             gn-PY            Guarani (Paraguay)                                                                                       
        132              gsw              Alsatian                                                                                                 
        1156             gsw-FR           Alsatian (France)                                                                                        
        71               gu               Gujarati                                                                                                 
        1095             gu-IN            Gujarati (India)                                                                                         
        104              ha               Hausa                                                                                                    
        31848            ha-Latn          Hausa (Latin)                                                                                            
        1128             ha-Latn-NG       Hausa (Latin, Nigeria)                                                                                   
        117              haw              Hawaiian                                                                                                 
        1141             haw-US           Hawaiian (United States)                                                                                 
        13               he               Hebrew                                                                                                   
        1037             he-IL            Hebrew (Israel)                                                                                          
        57               hi               Hindi                                                                                                    
        1081             hi-IN            Hindi (India)                                                                                            
        26               hr               Croatian                                                                                                 
        4122             hr-BA            Croatian (Latin, Bosnia and Herzegovina)                                                                 
        1050             hr-HR            Croatian (Croatia)                                                                                       
        46               hsb              Upper Sorbian                                                                                            
        1070             hsb-DE           Upper Sorbian (Germany)                                                                                  
        14               hu               Hungarian                                                                                                
        1038             hu-HU            Hungarian (Hungary)                                                                                      
        43               hy               Armenian                                                                                                 
        1067             hy-AM            Armenian (Armenia)                                                                                       
        105              ibb              Ibibio                                                                                                   
        1129             ibb-NG           Ibibio (Nigeria)                                                                                         
        33               id               Indonesian                                                                                               
        1057             id-ID            Indonesian (Indonesia)                                                                                   
        112              ig               Igbo                                                                                                     
        1136             ig-NG            Igbo (Nigeria)                                                                                           
        120              ii               Yi                                                                                                       
        1144             ii-CN            Yi (PRC)                                                                                                 
        15               is               Icelandic                                                                                                
        1039             is-IS            Icelandic (Iceland)                                                                                      
        16               it               Italian                                                                                                  
        2064             it-CH            Italian (Switzerland)                                                                                    
        1040             it-IT            Italian (Italy)                                                                                          
        93               iu               Inuktitut                                                                                                
        30813            iu-Cans          Inuktitut (Syllabics)                                                                                    
        1117             iu-Cans-CA       Inuktitut (Syllabics, Canada)                                                                            
        31837            iu-Latn          Inuktitut (Latin)                                                                                        
        2141             iu-Latn-CA       Inuktitut (Latin, Canada)                                                                                
        17               ja               Japanese                                                                                                 
        1041             ja-JP            Japanese (Japan)                                                                                         
        55               ka               Georgian                                                                                                 
        1079             ka-GE            Georgian (Georgia)                                                                                       
        63               kk               Kazakh                                                                                                   
        1087             kk-KZ            Kazakh (Kazakhstan)                                                                                      
        111              kl               Greenlandic                                                                                              
        1135             kl-GL            Greenlandic (Greenland)                                                                                  
        83               km               Khmer                                                                                                    
        1107             km-KH            Khmer (Cambodia)                                                                                         
        75               kn               Kannada                                                                                                  
        1099             kn-IN            Kannada (India)                                                                                          
        18               ko               Korean                                                                                                   
        1042             ko-KR            Korean (Korea)                                                                                           
        87               kok              Konkani                                                                                                  
        1111             kok-IN           Konkani (India)                                                                                          
        113              kr               Kanuri                                                                                                   
        1137             kr-NG            Kanuri (Nigeria)                                                                                         
        96               ks               Kashmiri                                                                                                 
        1120             ks-Arab          Kashmiri (Perso-Arabic)                                                                                  
        2144             ks-Deva-IN       Kashmiri (Devanagari, India)                                                                             
        146              ku               Central Kurdish                                                                                          
        31890            ku-Arab          Central Kurdish (Arabic)                                                                                 
        1170             ku-Arab-IQ       Central Kurdish (Iraq)                                                                                   
        64               ky               Kyrgyz                                                                                                   
        1088             ky-KG            Kyrgyz (Kyrgyzstan)                                                                                      
        118              la               Latin                                                                                                    
        1142             la-001           Latin (World)                                                                                            
        110              lb               Luxembourgish                                                                                            
        1134             lb-LU            Luxembourgish (Luxembourg)                                                                               
        84               lo               Lao                                                                                                      
        1108             lo-LA            Lao (Lao P.D.R.)                                                                                         
        39               lt               Lithuanian                                                                                               
        1063             lt-LT            Lithuanian (Lithuania)                                                                                   
        38               lv               Latvian                                                                                                  
        1062             lv-LV            Latvian (Latvia)                                                                                         
        129              mi               Maori                                                                                                    
        1153             mi-NZ            Maori (New Zealand)                                                                                      
        47               mk               Macedonian (FYROM)                                                                                       
        1071             mk-MK            Macedonian (Former Yugoslav Republic of Macedonia)                                                       
        76               ml               Malayalam                                                                                                
        1100             ml-IN            Malayalam (India)                                                                                        
        80               mn               Mongolian                                                                                                
        30800            mn-Cyrl          Mongolian (Cyrillic)                                                                                     
        1104             mn-MN            Mongolian (Cyrillic, Mongolia)                                                                           
        31824            mn-Mong          Mongolian (Traditional Mongolian)                                                                        
        2128             mn-Mong-CN       Mongolian (Traditional Mongolian, PRC)                                                                   
        3152             mn-Mong-MN       Mongolian (Traditional Mongolian, Mongolia)                                                              
        88               mni              Manipuri                                                                                                 
        1112             mni-IN           Manipuri (India)                                                                                         
        124              moh              Mohawk                                                                                                   
        1148             moh-CA           Mohawk (Mohawk)                                                                                          
        78               mr               Marathi                                                                                                  
        1102             mr-IN            Marathi (India)                                                                                          
        62               ms               Malay                                                                                                    
        2110             ms-BN            Malay (Brunei Darussalam)                                                                                
        1086             ms-MY            Malay (Malaysia)                                                                                         
        58               mt               Maltese                                                                                                  
        1082             mt-MT            Maltese (Malta)                                                                                          
        85               my               Burmese                                                                                                  
        1109             my-MM            Burmese (Myanmar)                                                                                        
        31764            nb               Norwegian (Bokmål)                                                                                       
        1044             nb-NO            Norwegian, Bokmål (Norway)                                                                               
        97               ne               Nepali                                                                                                   
        2145             ne-IN            Nepali (India)                                                                                           
        1121             ne-NP            Nepali (Nepal)                                                                                           
        19               nl               Dutch                                                                                                    
        2067             nl-BE            Dutch (Belgium)                                                                                          
        1043             nl-NL            Dutch (Netherlands)                                                                                      
        30740            nn               Norwegian (Nynorsk)                                                                                      
        2068             nn-NO            Norwegian, Nynorsk (Norway)                                                                              
        20               no               Norwegian                                                                                                
        108              nso              Sesotho sa Leboa                                                                                         
        1132             nso-ZA           Sesotho sa Leboa (South Africa)                                                                          
        130              oc               Occitan                                                                                                  
        1154             oc-FR            Occitan (France)                                                                                         
        114              om               Oromo                                                                                                    
        1138             om-ET            Oromo (Ethiopia)                                                                                         
        72               or               Odia                                                                                                     
        1096             or-IN            Odia (India)                                                                                             
        70               pa               Punjabi                                                                                                  
        31814            pa-Arab          Punjabi (Arabic)                                                                                         
        2118             pa-Arab-PK       Punjabi (Islamic Republic of Pakistan)                                                                   
        1094             pa-IN            Punjabi (India)                                                                                          
        121              pap              Papiamento                                                                                               
        1145             pap-029          Papiamento (Caribbean)                                                                                   
        21               pl               Polish                                                                                                   
        1045             pl-PL            Polish (Poland)                                                                                          
        140              prs              Dari                                                                                                     
        1164             prs-AF           Dari (Afghanistan)                                                                                       
        99               ps               Pashto                                                                                                   
        1123             ps-AF            Pashto (Afghanistan)                                                                                     
        22               pt               Portuguese                                                                                               
        1046             pt-BR            Portuguese (Brazil)                                                                                      
        2070             pt-PT            Portuguese (Portugal)                                                                                    
        134              quc              K'iche'                                                                                                  
        31878            quc-Latn         K'iche'                                                                                                  
        1158             quc-Latn-GT      K'iche' (Guatemala)                                                                                      
        107              quz              Quechua                                                                                                  
        1131             quz-BO           Quechua (Bolivia)                                                                                        
        2155             quz-EC           Quechua (Ecuador)                                                                                        
        3179             quz-PE           Quechua (Peru)                                                                                           
        23               rm               Romansh                                                                                                  
        1047             rm-CH            Romansh (Switzerland)                                                                                    
        24               ro               Romanian                                                                                                 
        2072             ro-MD            Romanian (Moldova)                                                                                       
        1048             ro-RO            Romanian (Romania)                                                                                       
        25               ru               Russian                                                                                                  
        2073             ru-MD            Russian (Moldova)                                                                                        
        1049             ru-RU            Russian (Russia)                                                                                         
        135              rw               Kinyarwanda                                                                                              
        1159             rw-RW            Kinyarwanda (Rwanda)                                                                                     
        79               sa               Sanskrit                                                                                                 
        1103             sa-IN            Sanskrit (India)                                                                                         
        133              sah              Sakha                                                                                                    
        1157             sah-RU           Sakha (Russia)                                                                                           
        89               sd               Sindhi                                                                                                   
        31833            sd-Arab          Sindhi (Arabic)                                                                                          
        2137             sd-Arab-PK       Sindhi (Islamic Republic of Pakistan)                                                                    
        1113             sd-Deva-IN       Sindhi (Devanagari, India)                                                                               
        59               se               Sami (Northern)                                                                                          
        3131             se-FI            Sami, Northern (Finland)                                                                                 
        1083             se-NO            Sami, Northern (Norway)                                                                                  
        2107             se-SE            Sami, Northern (Sweden)                                                                                  
        91               si               Sinhala                                                                                                  
        1115             si-LK            Sinhala (Sri Lanka)                                                                                      
        27               sk               Slovak                                                                                                   
        1051             sk-SK            Slovak (Slovakia)                                                                                        
        36               sl               Slovenian                                                                                                
        1060             sl-SI            Slovenian (Slovenia)                                                                                     
        30779            sma              Sami (Southern)                                                                                          
        6203             sma-NO           Sami, Southern (Norway)                                                                                  
        7227             sma-SE           Sami, Southern (Sweden)                                                                                  
        31803            smj              Sami (Lule)                                                                                              
        4155             smj-NO           Sami, Lule (Norway)                                                                                      
        5179             smj-SE           Sami, Lule (Sweden)                                                                                      
        28731            smn              Sami (Inari)                                                                                             
        9275             smn-FI           Sami, Inari (Finland)                                                                                    
        29755            sms              Sami (Skolt)                                                                                             
        8251             sms-FI           Sami, Skolt (Finland)                                                                                    
        119              so               Somali                                                                                                   
        1143             so-SO            Somali (Somalia)                                                                                         
        28               sq               Albanian                                                                                                 
        1052             sq-AL            Albanian (Albania)                                                                                       
        31770            sr               Serbian                                                                                                  
        27674            sr-Cyrl          Serbian (Cyrillic)                                                                                       
        7194             sr-Cyrl-BA       Serbian (Cyrillic, Bosnia and Herzegovina)                                                               
        12314            sr-Cyrl-ME       Serbian (Cyrillic, Montenegro)                                                                           
        10266            sr-Cyrl-RS       Serbian (Cyrillic, Serbia)                                                                               
        28698            sr-Latn          Serbian (Latin)                                                                                          
        6170             sr-Latn-BA       Serbian (Latin, Bosnia and Herzegovina)                                                                  
        11290            sr-Latn-ME       Serbian (Latin, Montenegro)                                                                              
        9242             sr-Latn-RS       Serbian (Latin, Serbia)                                                                                  
        48               st               Southern Sotho                                                                                           
        1072             st-ZA            Southern Sotho (South Africa)                                                                            
        29               sv               Swedish                                                                                                  
        2077             sv-FI            Swedish (Finland)                                                                                        
        1053             sv-SE            Swedish (Sweden)                                                                                         
        65               sw               Kiswahili                                                                                                
        1089             sw-KE            Kiswahili (Kenya)                                                                                        
        90               syr              Syriac                                                                                                   
        1114             syr-SY           Syriac (Syria)                                                                                           
        73               ta               Tamil                                                                                                    
        1097             ta-IN            Tamil (India)                                                                                            
        2121             ta-LK            Tamil (Sri Lanka)                                                                                        
        74               te               Telugu                                                                                                   
        1098             te-IN            Telugu (India)                                                                                           
        40               tg               Tajik                                                                                                    
        31784            tg-Cyrl          Tajik (Cyrillic)                                                                                         
        1064             tg-Cyrl-TJ       Tajik (Cyrillic, Tajikistan)                                                                             
        30               th               Thai                                                                                                     
        1054             th-TH            Thai (Thailand)                                                                                          
        115              ti               Tigrinya                                                                                                 
        2163             ti-ER            Tigrinya (Eritrea)                                                                                       
        1139             ti-ET            Tigrinya (Ethiopia)                                                                                      
        66               tk               Turkmen                                                                                                  
        1090             tk-TM            Turkmen (Turkmenistan)                                                                                   
        50               tn               Setswana                                                                                                 
        2098             tn-BW            Setswana (Botswana)                                                                                      
        1074             tn-ZA            Setswana (South Africa)                                                                                  
        31               tr               Turkish                                                                                                  
        1055             tr-TR            Turkish (Turkey)                                                                                         
        49               ts               Tsonga                                                                                                   
        1073             ts-ZA            Tsonga (South Africa)                                                                                    
        68               tt               Tatar                                                                                                    
        1092             tt-RU            Tatar (Russia)                                                                                           
        95               tzm              Tamazight                                                                                                
        1119             tzm-Arab-MA      Central Atlas Tamazight (Arabic, Morocco)                                                                
        31839            tzm-Latn         Tamazight (Latin)                                                                                        
        2143             tzm-Latn-DZ      Tamazight (Latin, Algeria)                                                                               
        30815            tzm-Tfng         Tamazight (Tifinagh)                                                                                     
        4191             tzm-Tfng-MA      Central Atlas Tamazight (Tifinagh, Morocco)                                                              
        128              ug               Uyghur                                                                                                   
        1152             ug-CN            Uyghur (PRC)                                                                                             
        34               uk               Ukrainian                                                                                                
        1058             uk-UA            Ukrainian (Ukraine)                                                                                      
        32               ur               Urdu                                                                                                     
        2080             ur-IN            Urdu (India)                                                                                             
        1056             ur-PK            Urdu (Islamic Republic of Pakistan)                                                                      
        67               uz               Uzbek                                                                                                    
        30787            uz-Cyrl          Uzbek (Cyrillic)                                                                                         
        2115             uz-Cyrl-UZ       Uzbek (Cyrillic, Uzbekistan)                                                                             
        31811            uz-Latn          Uzbek (Latin)                                                                                            
        1091             uz-Latn-UZ       Uzbek (Latin, Uzbekistan)                                                                                
        51               ve               Venda                                                                                                    
        1075             ve-ZA            Venda (South Africa)                                                                                     
        42               vi               Vietnamese                                                                                               
        1066             vi-VN            Vietnamese (Vietnam)                                                                                     
        136              wo               Wolof                                                                                                    
        1160             wo-SN            Wolof (Senegal)                                                                                          
        52               xh               isiXhosa                                                                                                 
        1076             xh-ZA            isiXhosa (South Africa)                                                                                  
        61               yi               Yiddish                                                                                                  
        1085             yi-001           Yiddish (World)                                                                                          
        106              yo               Yoruba                                                                                                   
        1130             yo-NG            Yoruba (Nigeria)                                                                                         
        30724            zh               Chinese                                                                                                  
        2052             zh-CN            Chinese (Simplified, PRC)                                                                                
        4                zh-Hans          Chinese (Simplified)                                                                                     
        31748            zh-Hant          Chinese (Traditional)                                                                                    
        3076             zh-HK            Chinese (Traditional, Hong Kong S.A.R.)                                                                  
        5124             zh-MO            Chinese (Traditional, Macao S.A.R.)                                                                      
        4100             zh-SG            Chinese (Simplified, Singapore)                                                                          
        1028             zh-TW            Chinese (Traditional, Taiwan)                                                                            
        53               zu               isiZulu                                                                                                  
        1077             zu-ZA            isiZulu (South Africa)                                                                                   

    
    .PARAMETER LanguageTag
    like de-de 
    
    .EXAMPLE
    Update-OSDisplyLanguage "zh-hans"
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$LanguageTag = "de-de" 
    )
    process{
        
        # Install required language
        # Check if the required language is available
        $osInfo = Get-WmiObject -Class Win32_OperatingSystem
        $languagePacks = $osInfo.MUILanguages

        # if not availabe, install language
        if($languagePacks -notcontains $LanguageTag)
        {
            $lpPath = Get-MUIPackagePath $LanguageTag
            if($lpPath -ne $null)
            {
                Add-WindowsPackage -Online -PackagePath $lpPath
                Write-Log "You need to restart the computer to be able to use this new language pack."
                Restart-Computer -Force -Confirm
            }
            else 
            {
                Write-Log "This language pack $LanguageTag is not installed. Please install at first."
            }         
        }
        else 
        {
           try {
                #set OS disply language 
                Set-Culture $LanguageTag
                Set-WinSystemLocale $LanguageTag
                Set-WinHomeLocation $(Get-GeoId($LanguageTag))
                Set-WinUserLanguageList $LanguageTag -force
                Write-Host "Successfully change the system display language to :"$LanguageTag"."
                GetChoice 
           }
           catch {
               Write-Exception $_.Exception
           }
            
        }
  
    }

}

Function Get-GeoId($Name='*')
{
    $cultures = [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures') #| Out-GridView
    foreach($culture in $cultures)
    {
        try{
            $region = [System.Globalization.RegionInfo]$culture.Name
            
            if($region.Name -like $Name)
            {
               return $region.GeoId
            }
        }
        catch {
            Write-Execption $_Exception
        }
    }
}
Function Get-MUIPackagePath($LanguageTag="de-de")
{
    [string]$languagePacksPath = "\\dcsrdgmasa\GMAS\GOLD\OS\Windows_Server_2012_R2_MUI\x64"
    $LanguageTagPath = Get-ChildItem -Path $languagePacksPath -Filter $LanguageTag
    if($LanguageTagPath -ne $null)
    {
        $lpPath = $LanguageTagPath.FullName + "\lp.cab"
        if(Test-Path -PathType Leaf $lpPath)
        {
            return $lpPath
        }
    }
}

Function GetChoice
{
    #Prompt message
    $Caption = "Logoff needed."
    $Message = "It will take effect after logoff the current user, do you want to logoff right now?"
    $Choices = [System.Management.Automation.Host.ChoiceDescription[]]`
        @("&Yes","&No")
    [Int]$DefaultChoice = 0
    $ChoiceRTN = $Host.UI.PromptForChoice($Caption, $Message, $Choices, $DefaultChoice)
        
    Switch ($ChoiceRTN)
    {
        0 {Logoff}
        1 {break}
    }
}

Export-ModuleMember -Function Update-OSDisplayLanguage

