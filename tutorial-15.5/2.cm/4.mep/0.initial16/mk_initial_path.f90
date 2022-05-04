
  implicit none

  character(80)  :: rPDB, pPDB, aimg, path, pathPDB
  character(120) :: line
  integer        :: natom, nimage
  integer        :: nargs
  integer        :: i,j,k, n
  real(8), allocatable  :: xr(:,:), xp(:,:), xi(:,:)
  real(8)        :: fac
  
    nargs = iargc()
    if (nargs < 3) then
      write(6,*) 'USAGE: ./mk_initial_path reactant.pdb product.pdb nImage [output]' 
      write(6,*) 'reactant.pdb : PDB file of a reactant'
      write(6,*) 'product.pdb  : PDB file of a reactant'
      write(6,*) 'nImage       : The number of image between reactant and product'
      write(6,*) 'output       : (optional) The name of the output PDB'
      stop
    end if

    call getarg(1, rPDB) 
    call getarg(2, pPDB) 
    call getarg(3, aimg) 
    read(aimg,*) nimage

    if (nargs > 3) then
      call getarg(4, path)
    else
      path='initial'
    end if

    write(6,*) 'Input parameters'
    write(6,*) ' o Reactant : ',trim(rPDB)
    write(6,*) ' o Product  : ',trim(pPDB)
    write(6,*) ' o Number of images :',nimage
    write(6,*) 
    write(6,*) 'Read PDB files'

    ! reactant 
    open(10,file=rPDB,status='old')
    natom=0
    do while(.true.)
      read(10,'(a)', end=100) line
      if (line(1:4) == 'ATOM') natom=natom+1
    end do
100 continue

    write(6,*) ' o Number of atoms  :',natom

    rewind(10)
    allocate(xr(3,natom))

    n=0
    do while(.true.)
      read(10,'(a)', end=110) line
      if (line(1:4) == 'ATOM') then
        n=n+1
        read(line(30:54),*) xr(:,n)
      end if
    end do
110 continue

    close(10)

    ! product
    open(10,file=pPDB,status='old')
    n=0
    do while(.true.)
      read(10,'(a)', end=200) line
      if(line(1:4)=='ATOM') n=n+1
    end do
200 continue

    if (n /= natom) then
      write(6,*) 'ERROR: The nuber of atoms are different between reactant and product'
      write(6,*) 'ERROR: num_atoms (reactant) = ',natom
      write(6,*) 'ERROR: num_atoms (product ) = ',n
    end if

    allocate(xp(3,natom))
    rewind(10)

    n=0
    do while(.true.)
      read(10,'(a)', end=210) line
      if (line(1:4) == 'ATOM') then
        n=n+1
        read(line(30:54),*) xp(:,n)
      end if
    end do
210 continue

    close(10)

    ! generate initial path
    do i = 1, nimage
      fac = dble(i-1)/dble(nimage-1)
      xi  = xr + fac*(xp - xr)

      open(10,file=pPDB,status='unknown')
      write(pathPDB,'(a,i0,".pdb")') trim(path),i
      open(11,file=pathPDB,status='unknown')

      n=0
      do while(.true.)
        read(10,'(a)', end=300) line
        if(line(1:4)=='ATOM') then
          n=n+1
          write(11,'(a,3f8.3,a)') line(1:30),xi(:,n),line(55:76)
        else
          write(11,'(a)') trim(line)
        endif

      end do
300   continue

      close(10)
      close(11)

    end do

    ! end
    deallocate(xr,xp)

  end

