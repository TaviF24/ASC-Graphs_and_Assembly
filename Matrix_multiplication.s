.data
	cerinta: .space 4
	nr_noduri: .space 4
	noduri: .space 400 
	element: .space 4
	matrice: .space 40000
	mres: .space 40000
	mres_copie: .space 40000
	nr_leg: .space 4
	
	n: .space 4
	lungime_drum: .space 4
	sursa: .space 4
	destinatie: .space 4
	
	formatscan: .asciz "%d"
	formatprint: .asciz "%d "
	formatprint_cerinta2: .asciz "%d"
	formatendline: .asciz "%s"
	endline: .asciz "\n" 
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
		
	init_matrice:
		lea matrice, %edi
		movl $0, %ecx
		
		for_linie:
			cmp nr_noduri, %ecx
			je citire_nr_legaturi
			
			movl %ecx, %eax
			xorl %edx, %edx
			mull nr_noduri
			xorl %ebx, %ebx
			
			for_coloana:
				cmp nr_noduri, %ebx
				je for_linie_cont
				
				movl $0,(%edi,%eax,4)
				inc %ebx
				inc %eax
				jmp for_coloana
		for_linie_cont:
			inc %ecx
			jmp for_linie
	
	
	citire_nr_legaturi:
		lea noduri, %edi
		xorl %ecx, %ecx
		
		for_citire:
			cmp nr_noduri, %ecx
			je citire_noduri
			
			pushl %ecx
			pushl $nr_leg
			pushl $formatscan
			call scanf
			popl %edx
			popl %edx
			popl %ecx
			
			movl nr_leg, %eax
			movl %eax, (%edi,%ecx,4)
			inc %ecx
			jmp for_citire
	
	citire_noduri:
		lea noduri, %esi
		xorl %ecx, %ecx
		
		for_parc_vect:
			cmp nr_noduri, %ecx
			je if_cerinta
			
			movl (%esi,%ecx,4), %edx
			movl %edx, nr_leg
			xorl %ebx, %ebx
			
			for_parc_elem_vect:
				cmp nr_leg,%ebx
				je cont_for_parc_vect
				
				pusha
				pushl $element
				pushl $formatscan
				call scanf
				popl %edx
				popl %edx
				popa
				
				lea matrice, %edi
				xorl %edx, %edx
				movl %ecx, %eax
				mull nr_noduri
				addl element,%eax
				movl $1,(%edi,%eax,4) 
				
				inc %ebx
				jmp for_parc_elem_vect
			
		cont_for_parc_vect:	
			inc %ecx
			jmp for_parc_vect
	
	if_cerinta:
		movl $1, %eax
		cmp cerinta, %eax
		je cerinta1
		
		movl $2, %eax
		cmp cerinta, %eax
		je cerinta2
			
	cerinta1:
		lea matrice, %esi
		movl $0, %ecx
		
		for_linie2:
			cmp nr_noduri, %ecx
			je sf_c_1
			
			movl %ecx, %eax
			xorl %edx, %edx
			mull nr_noduri
			xorl %ebx, %ebx
			
			for_coloana2:
				cmp nr_noduri, %ebx
				je for_linie_cont2
				
				pusha
				pushl (%esi,%eax,4)
				pushl $formatprint
				call printf
				popl %edx
				popl %edx
				popa
				
				pusha
				pushl $0
				call fflush
				popl %edx
				popa
				
				inc %ebx
				inc %eax
				jmp for_coloana2
		for_linie_cont2:
			pusha
			pushl $endline
			pushl $formatendline
			call printf
			popl %edx
			popl %edx
			popa
				
			pusha
			pushl $0
			call fflush
			popl %edx
			popa
		
			inc %ecx
			jmp for_linie2	
	sf_c_1:
		jmp exit	
		
	cerinta2:
		pusha
		pushl $lungime_drum
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		popa
		
		pusha
		pushl $sursa
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		popa
		
		pusha
		pushl $destinatie
		pushl $formatscan
		call scanf
		popl %edx
		popl %edx
		popa
		
		jmp verificare_drum
		
		caz_lungime_e_1:
			lea mres, %edi
			lea matrice, %esi
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
			pushl $mres
			pushl $matrice
			pushl $matrice
			call matrix_mult
			popl %edx
			popl %edx
			popl %edx
			popl %edx
		popl %ecx
		inc %ecx
		
		for_lungime:
			cmp lungime_drum, %ecx
			je rezultat
			
			pushl %ecx
		
			lea mres, %esi
			lea mres_copie, %edi
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
				pushl $mres
				pushl $mres_copie
				pushl $matrice
				call matrix_mult
				popl %edx
				popl %edx
				popl %edx
				popl %edx
				
			popl %ecx
				
			inc %ecx
			jmp for_lungime
				
	rezultat: 
		lea mres, %esi
		movl sursa, %eax
		xorl %edx, %edx
		mull nr_noduri
		addl destinatie, %eax
		
		pushl (%esi,%eax,4)
		pushl $formatprint_cerinta2
		call printf
		popl %edx
		popl %edx
	
		pushl $0
		call fflush
		popl %edx
		
	exit:
		movl $1, %eax
		xorl %ebx, %ebx
		int $0x80
