from Bio import SeqIO

def analyze_annotations(file_path):
    gene_lengths = [
        len(feature.location) 
        for record in SeqIO.parse(file_path, "genbank") 
        for feature in record.features if feature.type == "gene"
    ]
    num_genes = len(gene_lengths)
    avg_gene_length = sum(gene_lengths) / num_genes if num_genes else 0
    return num_genes, avg_gene_length

def count_polymerase_genes(file_path):
    keywords = ["RNA polymerase", "DNA polymerase"]
    polymerase_genes = 0

    for record in SeqIO.parse(file_path, "genbank"):
        polymerase_genes += sum(
            1 for feature in record.features
            if feature.type in ["CDS", "gene"] and 
            "product" in feature.qualifiers and 
            any(kw in feature.qualifiers["product"][0] for kw in keywords)
        )
    
    return polymerase_genes

bakta_file = "assembly.gbff"
prokka_file = "assembly.gbk"

bakta_stats = analyze_annotations(bakta_file)
prokka_stats = analyze_annotations(prokka_file)

num_bakta_polymerases = count_polymerase_genes(bakta_file)
num_prokka_polymerases = count_polymerase_genes(prokka_file)

print("Podsumowanie analizy:")
print(f"Bakta - Liczba genów: {bakta_stats[0]}, Średnia długość: {bakta_stats[1]:.2f}")
print(f"Prokka - Liczba genów: {prokka_stats[0]}, Średnia długość: {prokka_stats[1]:.2f}")
print(f"Bakta - Liczba genów polimeraz: {num_bakta_polymerases}")
print(f"Prokka - Liczba genów polimeraz: {num_prokka_polymerases}")
