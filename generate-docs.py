import os
import rdflib
from datetime import datetime
from pathlib import Path

htmldir = "./meta/html/"

for ttlpath in list(Path(".").rglob("*.ttl")): 

    g = rdflib.Graph()
    
    ttlfile = open(ttlpath, "r")
    result = g.parse(data=ttlfile.read(), format="turtle")
    print("PARSED\t" + str(ttlpath))

    try:
        os.makedirs(htmldir + str(ttlpath.parent))
    except FileExistsError:
        pass

    htmlpath = htmldir + str(ttlpath.parent) + "/" + ttlpath.stem + ".html"
    htmlfile = open(htmlpath, "w")
    for subject, predicate, object in g:
        htmlfile.write("\t".join([subject, predicate, object]))
        htmlfile.write("\n")
    htmlfile.close()
    print("WROTE\t" + htmlpath)

    

    



