def get_read_length(fastq_file):
        '''
    Get read length out of fastq file
    '''
            logging.info('Getting read lenth out of fastq file...')
                total_reads_to_consider = 1000000
                    line_num = 0
                        total_reads_considered = 0
                            max_length = 0
                                with getFileHandle(fastq_file, 'rb') as fp:
                                            for line in fp:
                                                            if line_num % 4 == 1:
                                                                                if len(line.strip()) > max_length:
                                                                                                        max_length = len(line.strip())
                                                                                                                        total_reads_considered += 1
                                                                                                                                    if total_reads_considered >= total_reads_to_consider:
                                                                                                                                                        break
                                                                                                                                                                line_num += 1
                                                                                                                                                                    logging.info('read length:'+str(max_length))
                                                                                                                                                                        return int(max_length)


                                                                                                                                                                    

def make_tss_plot(bam_file, tss, prefix, chromsizes, read_len, bins=400, bp_edge=2000,
                  processes=8, greenleaf_norm=True):
    '''
    Take bootstraps, generate tss plots, and get a mean and
    standard deviation on the plot. Produces 2 plots. One is the
    aggregation plot alone, while the other also shows the signal
    at each TSS ordered by strength.
    '''
    logging.info('Generating tss plot...')
    tss_plot_file = '{0}_tss-enrich.png'.format(prefix)
    tss_plot_data_file = '{0}_tss-enrich.txt'.format(prefix)    
    tss_plot_large_file = '{0}_large_tss-enrich.png'.format(prefix)

    # Load the TSS file
    tss = pybedtools.BedTool(tss)
    tss_ext = tss.slop(b=bp_edge, g=chromsizes)

    # Load the bam file
    bam = metaseq.genomic_signal(bam_file, 'bam') # Need to shift reads and just get ends, just load bed file?
    bam_array = bam.array(tss_ext, bins=bins, shift_width = -read_len/2, # Shift to center the read on the cut site
                          processes=processes, stranded=True)

    # Actually first build an "ends" file
    #get_ends = '''zcat {0} | awk -F '\t' 'BEGIN {{OFS="\t"}} {{if ($6 == "-") {{$2=$3-1; print}} else {{$3=$2+1; print}} }}' | gzip -c > {1}_ends.bed.gz'''.format(bed_file, prefix)
    #print(get_ends)
    #os.system(get_ends)

    #bed_reads = metaseq.genomic_signal('{0}_ends.bed.gz'.format(prefix), 'bed')
    #bam_array = bed_reads.array(tss_ext, bins=bins,
    #                      processes=processes, stranded=True)

    # Normalization (Greenleaf style): Find the avg height
    # at the end bins and take fold change over that
    if greenleaf_norm:
        # Use enough bins to cover 100 bp on either end
        num_edge_bins = int(100/(2*bp_edge/bins))
        bin_means = bam_array.mean(axis=0)
        avg_noise = (sum(bin_means[:num_edge_bins]) +
                     sum(bin_means[-num_edge_bins:]))/(2*num_edge_bins)
        bam_array /= avg_noise
    else:
        bam_array /= bam.mapped_read_count() / 1e6

    # Generate a line plot
    fig = plt.figure()
    ax = fig.add_subplot(111)
    x = np.linspace(-bp_edge, bp_edge, bins)

    ax.plot(x, bam_array.mean(axis=0), color='r', label='Mean')
    ax.axvline(0, linestyle=':', color='k')

    # Note the middle high point (TSS)
    tss_point_val = max(bam_array.mean(axis=0))

    ax.set_xlabel('Distance from TSS (bp)')
    ax.set_ylabel('Average read coverage (per million mapped reads)')
    ax.legend(loc='best')

    fig.savefig(tss_plot_file)

    # Print a more complicated plot with lots of info

    # write the plot data; numpy object
    np.savetxt(tss_plot_data_file,bam_array.mean(axis=0),delimiter=",")


    # Find a safe upper percentile - we can't use X if the Xth percentile is 0
    upper_prct = 99
    if mlab.prctile(bam_array.ravel(), upper_prct) == 0.0:
        upper_prct = 100.0

    plt.rcParams['font.size'] = 8
    fig = metaseq.plotutils.imshow(bam_array,
                                   x=x,
                                   figsize=(5, 10),
                                   vmin=5, vmax=upper_prct, percentile=True,
                                   line_kwargs=dict(color='k', label='All'),
                                   fill_kwargs=dict(color='k', alpha=0.3),
                                   sort_by=bam_array.mean(axis=1))

    # And save the file
    fig.savefig(tss_plot_large_file)

    return tss_plot_file, tss_plot_large_file, tss_point_val

def main():


        # Get read length
        read_len = get_read_length(FASTQ)
        
        # Parse args
        [NAME, OUTPUT_PREFIX, REF, TSS, DNASE, BLACKLIST, PROM, ENH,
               GENOME, CHROMSIZES, FASTQ, ALIGNED_BAM,
              ALIGNMENT_LOG, COORDSORT_BAM, DUP_LOG, PBC_LOG, FINAL_BAM,
              FINAL_BED, BIGWIG, PEAKS, USE_SAMBAMBA_MARKDUP] = parse_args()
        
    tss_plot_file, tss_plot_large_file, tss_point_val = make_tss_plot(FINAL_BAM,
                                                                      TSS,
                                                                      OUTPUT_PREFIX,
                                                                      CHROMSIZES,
                                                                      read_len)

