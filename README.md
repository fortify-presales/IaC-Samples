[![Fortify on Demand](https://github.com/kadraman/IaC-Samples/actions/workflows/fod.yml/badge.svg)](https://github.com/kadraman/IaC-Samples/actions/workflows/fod.yml)
# IaC-Samples

This is a collection of Infrastructure as Code (IaC) files with weaknesses/vulnerabilities that can be found by using Application
Security testing tools - such as [OpenText Application Security](https://www.opentext.com/products/application-security). 

Prerequisites
-------------

  - Local OpenText SAST install (for running scans locally)
  - Fortify CLI install -  [https://github.com/fortify/fcli](https://github.com/fortify/fcli)

Scan Application (with OpenText Application Security)
-----------------------------------------------------

To carry out a Fortify Static Code Analyzer local scan, run the following:

```
sourceanalyzer -b iac-samples .
sourceanalyzer -b iac-samples -scan -f IaC-Samples.fpr
```

To carry out a Fortify ScanCentral SAST scan, run the following:

```
fcli ssc session login
scancentral package -o package.zip -bt none
fcli sast-scan start --release "_YOURAPP_:_YOURREL_" -f package.zip --store curScan
fcli sast-scan wait-for ::curScan::
fcli ssc action run appversion-summary --av "_YOURAPP_:_YOURREL_" -fs "Security Auditor View" -f summary.md
```

To carry out a Fortify on Demand scan, run the following:

```
fcli fod session login
scancentral package -o package.zip -bt none
fcli fod sast-scan start --release "_YOURAPP_:_YOURREL_" -f package.zip --store curScan
fcli fod sast-scan wait-for ::curScan::
fcli fod action run release-summary --rel "_YOURAPP_:_YOURREL_" -f summary.md
```

---

Kevin A. Lee (kadraman) - klee2@opentext.com
