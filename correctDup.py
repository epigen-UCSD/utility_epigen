import argparse
def get_picard_dup_stats(picard_dup_file, paired_status):
    '''
    Parse Picard's MarkDuplicates metrics file
    '''
    mark = 0
    dup_stats = {}
    with open(picard_dup_file) as fp:
        for line in fp:
            if '##' in line:
                if 'METRICS CLASS' in line:
                    mark = 1
                continue

            if mark == 2:
                line_elems = line.strip().split('\t')
                dup_stats['PERCENT_DUPLICATION'] = line_elems[8] 
                dup_stats['READ_PAIR_DUPLICATES'] = line_elems[6]
                dup_stats['READ_PAIRS_EXAMINED'] = line_elems[2]
                if paired_status == 'Paired-ended':
                    return 2*int(line_elems[6]), float(line_elems[8])
                else:
                    return int(line_elems[5]), float(line_elems[8])

            if mark > 0:
                mark += 1
    return None

def main():
	parser = argparse.ArgumentParser(description='Correct dupQC.')
	parser.add_argument('--dup_file',help='dup log file')
	args = parser.parse_args()
	read_dups, percent_dup = get_picard_dup_stats(args.dup_file,'Paired-ended')
	print '{0}\t{1}'.format(read_dups,percent_dup)

if __name__ == '__main__':
    main()
