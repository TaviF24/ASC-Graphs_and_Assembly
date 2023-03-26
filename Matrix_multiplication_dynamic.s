.data
	cerinta: .space 4
	nr_noduri: .space 4
	pointer_vector_noduri: .space 4
	pointer_matrice: .space 4
	pointer_mres: .space 4
	pointer_copie_mres: .space 4
	lungime_drum: .space 4
	sursa: .space 4
	destinatie: .space 4
	n: .space 4
	
	formatprint: .asciz "%d"
	formatscan: .asciz "%d"
.text
	matrix_mult:
		pushl %ebp
		movl %esp, %ebp
		
		movl 16(%ebp), %edi
		movl 20(%ebp), %edx    #edx=nr elemente
		xorl %ecx, %ecx
		
		for_linie3:
			cmp %edx,%ecx
			je ret_et
			
			pushl %ecx
			xorl %ecx, %ecx
			
			for_coloana3:
				cmp %edx, %ecx
				je for_linie_cont3
				
				movl -4(%ebp), %eax
				
				pushl %edx
				movl %edx, %ebx
				xorl %edx, %edx
				mull %ebx
				addl %ecx, %eax
				movl $0, (%edi,%eax,4)
				popl %edx
				
				pushl %ecx
				xorl %ecx, %ecx
				
				for_inmultire_adunare:
					cmp %edx, %ecx
					je for_coloana_cont3
					
					movl %edx, %ebx    #ebx=nr elemente
					
					pushl %edx
					xorl %edx, %edx
					movl -4(%ebp), %eax
					mull %ebx
					addl %ecx, %eax
				
					movl 8(%ebp), %esi
					
					sub $4, %esp
					movl (%esi,%eax,4), %eax
					movl %eax, -16(%ebp)  # -16(ebp)= elementul cu indicele eax din m1	
					movl %ecx, %eax
					xorl %edx, %edx
					mull %ebx
					addl -8(%ebp), %eax
					
					pushl %ecx
					movl %eax, %ecx
					movl -16(%ebp), %eax  #eax=valoarea din m1
					movl 12(%ebp), %esi
					
					pushl %ebx
					movl (%esi,%ecx,4),%ebx #ebx=valoarea din m2
					xorl %edx, %edx
					mull %ebx	#eax=inmultirea elementelor din m1 m2
					popl %ebx
					
					popl %ecx
					addl $4, %esp
			
					pushl %eax
					movl -4(%ebp), %eax
					xorl %edx, %edx
					mull %ebx
					addl -8(%ebp), %eax  #eax=indicele lui mres
					
					movl %eax, %edx
					movl (%edi,%eax,4), %ebx
					popl %eax
					
					addl %eax, %ebx
					movl %edx, %eax
					movl %ebx, (%edi,%eax,4)
					
					popl %edx
					
					inc %ecx
					jmp for_inmultire_adunare
				
			for_coloana_cont3:
				popl %ecx
				inc %ecx
				jmp for_coloana3
		
		for_linie_cont3:
			popl %ecx
			inc %ecx
			jmp for_linie3
	
		ret_et:	
			popl %ebp
			ret	
	
	
.global main
	main:
		pushl $cerinta
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
	
		pushl $nr_noduri
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		
	alocare_vector_noduri:
		movl nr_noduri, %eax
		xorl %edx, %edx
		movl $4, %ebx
		mull %ebx
		
		movl %ebx, %ecx		#lungimea in bytes= nr_noduri*4
		
		movl $192, %eax		#192 este codul pentru apelul de sistem mmap2
		
		movl $0, %ebx		#0=NULL pentru ca nu conteaza unde se face alocarea in memorie, Kernel-ul alegand unde sa se faca maparea
		movl $3, %edx		#PROT_READ|PROT_WRITE
					#am pus valoarea 3, deoarece PROT_READ are valoarea 1, iar PROT_WRITE are valoarea 2
					#am folosit PROT_READ pentru ca zona de memorie mapata sa poata fi citita si PROT_WRITE pentru ca pe zona 
					#mapata sa se poata scrie
		
		movl $34, %esi		#MAP_PRIVATE|MAP_ANONYMOUS
					#am pus valoarea 34, deoarece MAP_PRIVATE are valoarea 2, iar MAP_ANONYMOUS are valoarea 32
					#am folosit MAP_PRIVATE pentru ca schimbarile in zona de memorie mapata sa nu fie vizibile si in alte 
					#procese care folosesc aceeasi zona de memorie. Am folosit MAP_ANONYMOUS pentru ca datele din zona de
					#memorie mapata(si modificarile aduse acolo) sa nu fie stocate intr-un file ce se afla pe disk, dupa 		
					#terminarea procesului(programului), acea memorie fiind golita.
					#continutul zonei de memorie in care se face alocarea este initializat cu 0.	
		
		movl $-1, %edi		#am pus valoarea -1 pentru ca file descriptor-ul este ignorat din cauza flag-ului MAP_ANONYMOUS, iar  
					#valoarea -1 este asemenea unui placeholder 
		
		xorl %ebp, %ebp		#am pus valoarea 0, deoarece flag-ul MAP_ANONYMOUS este folosit, 0 fiind o valoare default
		int $0x80
		
		movl %eax, pointer_vector_noduri
		xorl %ecx, %ecx
	
	
	for_citire:
		cmp nr_noduri, %ecx
		je alocare_matrice
			
		pushl %eax	
		
		pushl %ecx
		pushl %eax
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		popl %ecx
			
		popl %eax
			
		addl $4, %eax
		inc %ecx
		jmp for_citire
	
	
	alocare_matrice:
		movl nr_noduri, %eax
		xorl %edx, %edx
		mull nr_noduri
		movl $4, %ebx
		mull %ebx
		
		movl %ebx, %ecx		#lungimea in bytes= nr_noduri*nr_noduri*4
		
		movl $192, %eax		#192 este codul pentru apelul de sistem mmap2
		
		movl $0, %ebx		#0=NULL pentru ca nu conteaza unde se face alocarea in memorie, Kernel-ul alegand unde sa se faca maparea
		
		movl $3, %edx		#PROT_READ|PROT_WRITE
					#am pus valoarea 3, deoarece PROT_READ are valoarea 1, iar PROT_WRITE are valoarea 2
					#am folosit PROT_READ pentru ca zona de memorie mapata sa poata fi citita si PROT_WRITE pentru ca pe zona 
					#mapata sa se poata scrie
		
		movl $34, %esi		#MAP_PRIVATE|MAP_ANONYMOUS
					#am pus valoarea 34, deoarece MAP_PRIVATE are valoarea 2, iar MAP_ANONYMOUS are valoarea 32
					#am folosit MAP_PRIVATE pentru ca schimbarile in zona de memorie mapata sa nu fie vizibile si in alte 
					#procese care folosesc aceeasi zona de memorie. Am folosit MAP_ANONYMOUS pentru ca datele din zona de
					#memorie mapata(si modificarile aduse acolo) sa nu fie stocate intr-un file ce se afla pe disk, dupa 		
					#terminarea procesului(programului), acea memorie fiind golita.
					#continutul zonei de memorie in care se face alocarea este initializat cu 0.
					
		movl $-1, %edi		#am pus valoarea -1 pentru ca file descriptor-ul este ignorat din cauza flag-ului MAP_ANONYMOUS, iar  
					#valoarea -1 este asemenea unui placeholder
					
		xorl %ebp, %ebp		#am pus valoarea 0, deoarece flag-ul MAP_ANONYMOUS este folosit, 0 fiind o valoare default
		int $0x80
		movl %eax, pointer_matrice
		
		xorl %ecx, %ecx	
		movl pointer_vector_noduri, %esi	#esi=adresa vectorului de noduri
		
		
	for_init_matrice:
		cmp nr_noduri, %ecx
		je alocare_mres
		
		movl (%esi,%ecx,4), %ebx	# %ebx=nr de legaturi
		xorl %eax, %eax
		
		for_parc_elem_vect:
			cmp %ebx, %eax
			je for_init_matrice_cont
			
			pushl %eax
			pushl %ebx
			
			movl pointer_matrice, %eax
			movl (%eax), %ebx	# (%eax)=este folosit ca o variabila, pentru a stoca nodul citit
			
			pusha
			pushl %eax
			pushl $formatscan
			call scanf
			popl %edx
			popl %edx
			popa
			
			movl (%eax), %edx	# %edx=nodul citit, cel cu care se leaga
			movl %ebx, (%eax)	# s-a adus valoarea initiala a lui (%eax)
			movl %edx, %ebx
			xorl %edx, %edx
			movl %ecx, %eax
			mull nr_noduri
			addl %ebx, %eax 	# indicele elementului 1 din matrice
			
			popl %ebx

			movl pointer_matrice, %edi	# %edi=adresa matricei
			movl $1, (%edi,%eax,4)
			
			popl %eax
						
			inc %eax
			jmp for_parc_elem_vect
			
	for_init_matrice_cont:
		inc %ecx
		jmp for_init_matrice
			
	alocare_mres:
		movl nr_noduri, %eax
		xorl %edx, %edx
		mull nr_noduri
		movl $4, %ebx
		mull %ebx
		
		movl %ebx, %ecx		#lungimea in bytes= nr_noduri*nr_noduri*4
		
		movl $192, %eax		#192 este codul pentru apelul de sistem mmap2
		
		movl $0, %ebx		#0=NULL pentru ca nu conteaza unde se face alocarea in memorie, Kernel-ul alegand unde sa se faca maparea
		
		movl $3, %edx		#PROT_READ|PROT_WRITE
					#am pus valoarea 3, deoarece PROT_READ are valoarea 1, iar PROT_WRITE are valoarea 2
					#am folosit PROT_READ pentru ca zona de memorie mapata sa poata fi citita si PROT_WRITE pentru ca pe zona 
					#mapata sa se poata scrie
					
		movl $34, %esi		#MAP_PRIVATE|MAP_ANONYMOUS
					#am pus valoarea 34, deoarece MAP_PRIVATE are valoarea 2, iar MAP_ANONYMOUS are valoarea 32
					#am folosit MAP_PRIVATE pentru ca schimbarile in zona de memorie mapata sa nu fie vizibile si in alte 
					#procese care folosesc aceeasi zona de memorie. Am folosit MAP_ANONYMOUS pentru ca datele din zona de
					#memorie mapata(si modificarile aduse acolo) sa nu fie stocate intr-un file ce se afla pe disk, dupa 		
					#terminarea procesului(programului), acea memorie fiind golita.
					#continutul zonei de memorie in care se face alocarea este initializat cu 0.
					
		movl $-1, %edi		#am pus valoarea -1 pentru ca file descriptor-ul este ignorat din cauza flag-ului MAP_ANONYMOUS, iar  
					#valoarea -1 este asemenea unui placeholder
					
		xorl %ebp, %ebp		#am pus valoarea 0, deoarece flag-ul MAP_ANONYMOUS este folosit, 0 fiind o valoare default
		int $0x80
		movl %eax, pointer_mres
	
	if_cerinta:
		movl $3, %eax
		cmp cerinta, %eax
		jne exit
		
	cerinta3:
		pushl $lungime_drum
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
	
		pushl $sursa
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		
		pushl $destinatie
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		
		jmp verificare_drum
		
		caz_lungime_e_1:
			movl pointer_mres, %edi
			movl pointer_matrice, %esi
			xorl %ecx, %ecx
			
			for_l:
				cmp nr_noduri, %ecx
				je rezultat
				
				movl %ecx, %eax
				xorl %edx, %edx
				mull nr_noduri
				xorl %ebx, %ebx
				
				for_c:
					cmp nr_noduri, %ebx
					je for_l_cont
					
					movl (%esi,%eax,4), %edx
					movl %edx, (%edi,%eax,4)
									
					inc %ebx
					inc %eax
					jmp for_c
			for_l_cont:
				inc %ecx
				jmp for_l	
		
		verificare_drum:
			movl nr_noduri, %eax
			movl %eax, n
			movl $1, %ecx
			cmp lungime_drum, %ecx
			je caz_lungime_e_1
		
			pushl %ecx

		procedura:	
		       pushl n
		       pushl pointer_mres
		       pushl pointer_matrice
		       pushl pointer_matrice
		       call matrix_mult
		       popl %edx
		       popl %edx
		       popl %edx
		       popl %edx
         
		movl nr_noduri, %eax
		xorl %edx, %edx
		mull nr_noduri
		movl $4, %ebx
		mull %ebx
		
		movl %ebx, %ecx		#lungimea in bytes= nr_noduri*nr_noduri*4
		
		movl $192, %eax		#192 este codul pentru apelul de sistem mmap2
		
		movl $0, %ebx		#0=NULL pentru ca nu conteaza unde se face alocarea in memorie, Kernel-ul alegand unde sa se faca maparea
		
		movl $3, %edx		#PROT_READ|PROT_WRITE
					#am pus valoarea 3, deoarece PROT_READ are valoarea 1, iar PROT_WRITE are valoarea 2
					#am folosit PROT_READ pentru ca zona de memorie mapata sa poata fi citita si PROT_WRITE pentru ca pe zona 
					#mapata sa se poata scrie
					
		movl $34, %esi		#MAP_PRIVATE|MAP_ANONYMOUS
					#am pus valoarea 34, deoarece MAP_PRIVATE are valoarea 2, iar MAP_ANONYMOUS are valoarea 32
					#am folosit MAP_PRIVATE pentru ca schimbarile in zona de memorie mapata sa nu fie vizibile si in alte 
					#procese care folosesc aceeasi zona de memorie. Am folosit MAP_ANONYMOUS pentru ca datele din zona de
					#memorie mapata(si modificarile aduse acolo) sa nu fie stocate intr-un file ce se afla pe disk, dupa 		
					#terminarea procesului(programului), acea memorie fiind golita.
					#continutul zonei de memorie in care se face alocarea este initializat cu 0.
					
		movl $-1, %edi		#am pus valoarea -1 pentru ca file descriptor-ul este ignorat din cauza flag-ului MAP_ANONYMOUS, iar  
					#valoarea -1 este asemenea unui placeholder
					
		xorl %ebp, %ebp		#am pus valoarea 0, deoarece flag-ul MAP_ANONYMOUS este folosit, 0 fiind o valoare default
		int $0x80
		movl %eax, pointer_copie_mres   
		
		popl %ecx
		inc %ecx      
		             
		for_lungime_drum:
			cmp lungime_drum, %ecx
			je rezultat
			
			pushl %ecx
		
			movl pointer_mres, %esi
			movl pointer_copie_mres, %edi
			xorl %ecx, %ecx
			
			for_linie4:
				cmp nr_noduri, %ecx
				je proc
				
				movl %ecx, %eax
				xorl %edx, %edx
				mull nr_noduri
				xorl %ebx, %ebx
				
				for_coloana4:
					cmp nr_noduri, %ebx
					je for_linie_cont4
					
					movl (%esi,%eax,4), %edx
					movl %edx, (%edi,%eax,4)
									
					inc %ebx
					inc %eax
					jmp for_coloana4
			for_linie_cont4:
				inc %ecx
				jmp for_linie4	
			
			proc:	
				pushl n
				pushl pointer_mres
				pushl pointer_copie_mres
				pushl pointer_matrice
				call matrix_mult
				popl %edx
				popl %edx
				popl %edx
				popl %edx
				
			popl %ecx
				
			inc %ecx
			jmp for_lungime_drum             
		             
		rezultat:
			movl pointer_mres, %esi
			movl sursa, %eax
			xorl %edx, %edx
			mull nr_noduri
			addl destinatie, %eax		
			
			pushl (%esi,%eax,4)	#nr de drumuri
			pushl $formatprint
			call printf
			popl %edx
			popl %edx
					
			pushl $0
			call fflush
			popl %edx
			
		dealocare_copie_mres:
			movl nr_noduri, %eax
			xorl %edx, %edx
			mull nr_noduri
			movl $4, %ebx
			mull %ebx
			movl %eax, %ecx			#dimensiunea de dealocat
			movl pointer_copie_mres, %ebx	#adresa
			movl $91, %eax			#91 este codul pentru apelul de sistem munmap
			int $0x80
					
	dealocare_totala:
		movl nr_noduri, %eax
		xorl %edx, %edx
		movl $4, %ebx
		mull %ebx
	
		movl %eax, %ecx				#dimensiunea de dealocat
		movl pointer_vector_noduri, %ebx	#adresa
		movl $91, %eax				#91 este codul pentru apelul de sistem munmap
		int $0x80
	
		movl nr_noduri, %eax
		xorl %edx, %edx
		mull nr_noduri
		movl $4, %ebx
		mull %ebx
		movl %eax, %ecx
		
		pushl %ecx
		movl pointer_matrice, %ebx
		movl $91, %eax
		int $0x80
		popl %ecx
		
		pushl %ecx
		movl pointer_mres, %ebx
		movl $91, %eax
		int $0x80
		popl %ecx
		  
	exit:
		movl $1, %eax
		xorl %ebx, %ebx
		int $0x80
