
   implicit none

   integer, parameter :: natom=11, ndim = 5, nw = 21, nout = 5
   integer :: an(natom), group(natom), rr_idx(2,ndim)
   real(8) :: rr(ndim,nw), fc(ndim,nw)

   integer :: i,j,k
   integer :: ngrp, nfunction, nline, nsection, nline_sec(100)
   character(120) :: noshake, line, section(100,100)
   character(10)  :: id

     an(1)=1442  ! NE2 of HSE95
     an(2)=1443  ! HE2 of HSE95
     an(3)=2559  ! OE1 of GLU165
     an(4)=2560  ! OE2 of GLU165
     an(5)=7583  ! C2  of DHAP
     an(6)=7584  ! O2  of DHAP
     an(7)=7585  ! C3  of DHAP
     an(8)=7586  ! O3  of DHAP
     an(9)=7587  ! HO3 of DHAP
     an(10)=7588 ! H31 of DHAP
     an(11)=7589 ! H32 of DHAP
   
     rr_idx(:,1) = (/4, 10/)   ! OE2 - H31
     rr_idx(:,2) = (/7, 10/)   ! C3  - H31
     rr_idx(:,3) = (/3, 9/)    ! OE1 - HO3
     rr_idx(:,4) = (/6, 2/)    ! O2  - HE2
     rr_idx(:,5) = (/1, 9/)    ! NE2 - HO3

     fc = 100.0  ! kcal/mol/Angs^2

     open(10,file='../2.window/win_rr.dat',status='old')
     do i = 1, nw
       read(10,*) j, rr(:,i)
     end do
     close(10)
 
     open(10,file='prod3_temp.inp', status='old')

     nsection = 0
     do while(.true.)
       read(10,'(a)',end=10) line
       if (index(line,"#") > 0) then
         line(index(line,"#"):) = ''
       end if
       if (len(trim(line)) == 0) cycle

       if (index(line,"[") > 0 .and. index(line,"]") > 0) then
         if (nsection /= 0) nline_sec(nsection) = nline-1
         nsection = nsection + 1
         nline = 1
       end if

       section(nline,nsection) = line
       nline=nline + 1
     end do

     10 continue
     nline_sec(nsection) = nline-1

     close(10)

     do i = 1, nsection
       if (index(section(1,i),"SELEC") > 0) then
         j=index(section(nline_sec(i),i),"group")
         k=index(section(nline_sec(i),i),"=")
         read(section(nline_sec(i),i)(j+5:k-1),*) ngrp
         do j = 1, natom
           group(j) = j + ngrp

           nline_sec(i)=nline_sec(i) + 1
           write(section(nline_sec(i),i),'("group",i0," = atomno:",i0)') &
             group(j), an(j)
         end do
         exit
       end if
     end do

     do i = 1, nsection
       if (index(section(1,i),"CONST") > 0) then
         nline_sec(i) = nline_sec(i) + 1
         write(section(nline_sec(i),i),'("noshake_index   = ",10(i0,2x))') &
           group(2), group(9), group(10), group(11)
         exit
       end if
     end do

     do i = 1, nsection
       if (index(section(1,i),"RESTR") > 0) then
         read(section(2,i)(index(section(2,i),"=")+1:),*) nfunction
         write(section(2,i)(index(section(2,i),"=")+1:),'(1x,i0)') nfunction + ndim
         exit
       end if
     end do

     do i = 1, nw
       write(id,'(i0)') i
       open(11,file='prod3_'//trim(id)//'.inp',status='unknown')
       do j = 1, nsection
         do nline = 1, nline_sec(j)
           k = index(section(nline, j),"ID")
           if (k > 0) then
             write(11,'(a)') section(nline, j)(1:k-1)//trim(id)//trim(section(nline, j)(k+2:))
           else
             write(11,'(a)') trim(section(nline, j))
           end if
         end do

         if (index(section(1,j),"RESTR") > 0) then
           do k = 1, ndim
             write(11,'("function",i0,"  = DIST")')  nfunction+k
             write(11,'("constant",i0,"  = ",f8.1)') nfunction+k, fc(k,i) 
             write(11,'("reference",i0,"  = ",f10.4)')  nfunction+k, rr(k,i)
             write(11,'("select_index",i0,"  = ",2i4)') nfunction+k, group(rr_idx(:,k))
           end do
         end if

         write(11,*)
       end do
       close(11)
     end do

     open(11,file='reus.inp',status='unknown')
     write(11,'("[RESTRAINTS]")')
     write(11,'("nfunctions  = ",i0)') ndim
     do k = 1, ndim
       write(11,'("function",i0,"  = DIST")')  k
       write(11,'("constant",i0,"  = \")')     k
       do i = 1, nw
         write(11,'(f10.1,$)') fc(k,i) 
         if (i == nw) then
           write(11,*)
         else if (mod(i,nout) == 0) then
           write(11,'(" \")')
         end if
       end do
       write(11,'("reference",i0,"  = \")')  k
       do i = 1, nw
         write(11,'(f10.4,$)') rr(k,i) 
         if (i == nw) then
           write(11,*)
         else if (mod(i,nout) == 0) then
           write(11,'(" \")')
         end if
       end do
       write(11,'("select_index",i0,"  = ",2i4)') k, group(rr_idx(:,k))
       write(11,*)
     end do
     close(11)

   end
