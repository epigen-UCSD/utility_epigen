#!/usr/bin/env python2

# Split the tagged fastq.gz file into the tags user interested
import os
import re
import bz2
import gzip
import argparse


name_dics={'Human':'10000000','Mouse':'01000000', 'Rat':'00100000',
           'Cattle':'00010000','Ecoli':'00001000',
           'Mycoplasma':'00000100', 'PhiX':'00000010','Vectors':'00000001','NoHit':'00000000'}
name_dics_rev={v: k for k, v in name_dics.iteritems()}

def parseArgs():
    '''
    parse arguments 
    '''
    parser = argparse.ArgumentParser(description='fastqSpliter: split reads uniquely mapped to one genome and not mapped')
    parser.add_argument('--taggedFastq', help='tagged fastq file from fastq-screen')
    parser.add_argument('--prefix', help='Sample prefix name')
    parser.add_argument('--outDir', help='Output dir')    
    args = parser.parse_args()

    return args.taggedFastq, args.prefix, args.outDir


def getFileHandle(filename, mode="r"):
    if (re.search('.gz$',filename) or re.search('.gzip',filename)):
        if (mode=="r"):
            mode="rb";
        return gzip.open(filename,mode)
    elif (re.search('.bz2$',filename)):
        if(mode=="rb"):
            mode="r";
        return bz2.BZ2File(filename,mode)
    else:
        return open(filename,mode)

def splitReads(fastq_file,content_dic):
    '''
    Get read length out of fastq file
    '''
    line_num = 0
    with getFileHandle(fastq_file, 'rb') as fp:
        for line in fp:
            if line_num %4 ==0:
                tags=line.strip('\n').split(':')
            try:
                content_dic[tags[-1]].append(line)
            except KeyError:
                pass
            line_num=line_num + 1
    return content_dic


def writeFiles(content_dic,name_dics_rev,prefix,outDir):
    ''' 
    Write the split fastq from dic to files 
    '''
    for k,v in name_dics_rev.iteritems():
        fn=gzip.open('{0}.screen.{1}.fastq.gz'.format(os.path.join(outDir,prefix),v),'wb')
        for item in content_dic[k]:
            fn.write("%s" % item)
        fn.close()
    return None

def countReads(content_dic,name_dics):
    '''
    count Reads in each genome 

    counts = [len(content_dic[v]/4) for g,v in name_dics.iteritems()]
    counts.percent= ["{:.1%}".format(float(v)/sum(x)) for  v in x]
    for k in count.dic:
        count.dic[k].append(
    '''
    
    
def main():

    # parse args
    [taggedFastq,prefix,outDir] = parseArgs()
    
    # construct dict
    content_dic={k: [] for k,v in name_dics_rev.iteritems()}
    
    # split reads
    content_dic=splitReads(taggedFastq,content_dic)

    # write fastqs
    writeFiles(content_dic, name_dics_rev,prefix,outDir)

    return None

if __name__ == '__main__':
    main()

 
# fastqSpliter.py --taggedFastq H7-DMSO-1SNAP_S2_L001_R1_001.trim.tagged.fastq.gz --prefix H7-DMSO-1SNAP_S2_L001_R1_001 --outDir ./ 
