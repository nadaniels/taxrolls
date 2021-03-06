<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compact"/>

    <xsl:variable name="doc" select="document('./pers2.xml')"/>
    <xsl:variable name="refs" select="$doc//person"/>
    <xsl:key name="persID" match="person" use="@xml:id"/>

    <xsl:template match="/">

        
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="../enc.css"/>
            </head>

            <body>
                <!-- Header Links -->
                <xsl:copy-of select="document('./html/header.html')"/>

                <div class="flexbox">
                    <div class="side">
                        <div class="toc container">
                            <h3>Contents</h3>
                            <ul class="ul-disc">
                                <li><a href="#occupations">Occupations</a></li>
                                <li><a href="#names">Names</a></li>
                                <ul class="ul-disc">
                                    <li><a href="#given">Given Names</a></li>
                                    <li><a href="#toponyms">Toponyms</a></li>
                                </ul>
                                <li><a href="#people">Person IDs</a></li>
                            </ul>
                        </div>
                    </div>


                    <div class="main">

                        <!-- Occupation Index -->
                        <div class="container" id="occupations">
                            <h2>Occupations</h2>
                            <p>Unique Entries: <xsl:value-of select="count(distinct-values($refs/occupation/@role))"/></p>
                            <ul>
                                <xsl:for-each-group select="$refs//occupation" group-by="@role">
                                    <xsl:sort select="@role" lang="fr-FR"/>
                                    <li class="occ">
                                        <xsl:variable name="count" select="count(current-group())"/>

                                        <xsl:value-of select="current-grouping-key()"/>
                                        <xsl:if test="$count &gt; 1"> (<xsl:value-of select="$count"/>) </xsl:if>
                                        <ul>
                                            <xsl:for-each-group select="current-group()" group-by="normalize-space(./desc[@type = 'source'])" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                                                <xsl:sort select="count(current-group())" order="descending"/>
                                                <xsl:sort select="." collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                                <li class="occ_variant">
                                                    <xsl:value-of select="current-grouping-key()"/>
                                                    <xsl:if test="count(current-group()) != $count and count(current-group()) != 1"> (<xsl:value-of select="count(current-group())"/>) </xsl:if>
                                                    <ul>
                                                        <xsl:for-each select="current-group()">
                                                            <xsl:sort select="ancestor::person/persName[1]" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=tertiary;backwards=yes"/>
                                                            <li>
                                                                <!--<xsl:value-of select="key('persID', @xml:id)"/>-->
                                                                <xsl:variable name="source" select="ancestor::person/@xml:id"/>
                                                                <xsl:choose>
                                                                    <xsl:when test="ancestor::person/persName[@key][not(@type = 'reg')]">
                                                                        <a href="personography.html#{$source}">
                                                                            <xsl:value-of select="ancestor::person/persName/@key"/>
                                                                        </a>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <a href="personography.html#{$source}">
                                                                            <xsl:value-of select="normalize-space(ancestor::person/persName[1])"/>
                                                                        </a>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </li>
                                            </xsl:for-each-group>
                                        </ul>
                                    </li>
                                </xsl:for-each-group>
                            </ul>
                        </div>

                        <!-- Names Index -->
                        <div class="container" id="names">
                            <h2>Names</h2>
                            <h3 id="given">Given Names</h3>
                            <xsl:variable name="entries" select="$refs/persName[not(@type = 'reg')][forename]/lower-case(forename)"/>
                            <p>Unique Entries: <xsl:value-of select="count(distinct-values($entries))"/></p>
                            <ul>
                                <xsl:for-each-group select="$refs" group-by="./persName[not(@type = 'reg')]/forename" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                                    <xsl:sort select="./persName[1]/forename[1]" lang="fr-FR"/>
                                    <li>
                                        <xsl:value-of select="current-grouping-key()"/>
                                        <xsl:variable name="count" select="count(current-group())"/>
                                        <xsl:if test="$count &gt; 1"> (<xsl:value-of select="$count"/>)</xsl:if>
                                    </li>
                                </xsl:for-each-group>
                            </ul>
                            <h3 id="toponyms">Toponyms</h3>
                            <xsl:variable name="entries" select="$doc//persName[not(@type = 'reg')][descendant::placeName]/lower-case(descendant::placeName)"/>
                            <p>Unique Entries: <xsl:value-of select="count(distinct-values($entries))"/></p>
                            <ul>
                                <xsl:for-each-group select="$doc//persName[not(@type = 'reg')]" group-by="descendant::placeName" collation="http://www.w3.org/2013/collation/UCA?lang=fr;strength=secondary;backwards=yes">
                                    <xsl:sort select="descendant::placeName" lang="fr-FR"/>
                                    <li>
                                        <xsl:value-of select="current-grouping-key()"/>
                                        <xsl:variable name="count" select="count(current-group())"/>
                                        <xsl:if test="descendant::nameLink"> (<xsl:value-of select="descendant::nameLink"/>)</xsl:if>
                                        <xsl:if test="$count &gt; 1"> (<xsl:value-of select="$count"/>)</xsl:if>
                                    </li>
                                </xsl:for-each-group>
                            </ul>
                        </div>
                  
                        <!-- Person Index -->
                        <div class="container" id="people">
                            <h2>People (by ID)</h2>
                            <p>Unique Entries: <xsl:value-of select="count(distinct-values($refs/@xml:id))"/></p>
                            <ul class="name_index">
                                <xsl:for-each select="$refs">
                                    <xsl:sort select="@xml:id"/>
                                    <li>
                                        <xsl:value-of select="concat('#', @xml:id, ' ')"/>
                                        <a href="./personography.html#{@xml:id}">
                                            <xsl:value-of select="normalize-space(persName[1])"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    
                    </div>
                    <div class="side"></div>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
