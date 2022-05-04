
  module makedat

    Integer :: nreplica, iter, nelement, intvl
    real(8), allocatable :: path_length(:,:), energy(:,:), rel_energy(:,:)
    real(8), allocatable :: dist_data(:,:,:)
    character(:), allocatable :: basename

  end module


  Program main

  use makedat

  implicit none

  integer :: i, len, stat
  character(:), allocatable :: arg
  character(:), allocatable :: output, dist, interval
  intrinsic :: command_argument_count, get_command_argument

  if (command_argument_count() == 0) then
    write(6,'("USAGE: makedat -output rpath.out [-disout rpath_{}.dis] [-interval 10] [-basename rpath_]")')
    stop
  end if

  intvl = 10

  do i = 1, command_argument_count()
    call get_command_argument(i, length = len, status = stat)
    if (stat == 0) then
      allocate (character(len) :: arg)
      call get_command_argument(i, arg, status = stat)
      if (stat == 0) then
        if (index(arg,"-out") > 0) then
          call get_command_argument(i+1, length = len, status = stat)
          allocate (character(len) :: output)
          call get_command_argument(i+1, output, status = stat)

        else if (index(arg,"-dis") > 0) then
          call get_command_argument(i+1, length = len, status = stat)
          allocate (character(len) :: dist)
          call get_command_argument(i+1, dist, status = stat)

        else if (index(arg,"-int") > 0) then
          call get_command_argument(i+1, length = len, status = stat)
          allocate (character(len) :: interval)
          call get_command_argument(i+1, interval, status = stat)
          read(interval,*) intvl

        else if (index(arg,"-base") > 0) then
          call get_command_argument(i+1, length = len, status = stat)
          allocate (character(len) :: basename)
          call get_command_argument(i+1, basename, status = stat)

        end if
      end if
      deallocate (arg)
    end if
  end do

  if(.not. allocated(basename)) then
    allocate (character(6) :: basename)
    basename = "rpath_"
  end if

  write(6,'(" MakeDat v 0.1")')
  write(6,*)
  write(6,'(" o output   = ",a)') output
  write(6,'(" o disout   = ",a)') dist
  write(6,'(" o interval = ",i4)') intvl

  call read_genesis_output(output)
  write(6,'(" o nreplica = ",i4)') nreplica
  write(6,'(" o iter     = ",i4)') iter

  if (allocated(dist)) then
    call read_dis_file(dist)
    write(6,'(" o nelement = ",i4)') nelement
  end if

  call print_data()

  end program


  subroutine read_genesis_output(output)

  use makedat

  implicit none

  character(*)   :: output
  character(120) :: line
  integer        :: i, j

    nreplica = 0
    iter     = -1

    open(10,file=output,status='old')
    do while(.true.)
      read(10,'(a)', end=10) line
      if (index(line,"nreplica") > 0) then 
        read(line(54:64),*) nreplica

      else if (index(line,"Iter.") > 0) then 
        iter = iter + 1

      end if
    end do

    10 continue

    allocate(path_length(nreplica,0:iter))
    allocate(energy(nreplica,0:iter))
    allocate(rel_energy(nreplica,0:iter))

    rewind(10)

    j = 0
    do while(.true.)
      read(10,'(a)', end=20) line
      if (index(line,"Path Length") > 0) then 
        read(10,*)
        do i = 1, nreplica
          read(10,'(a)') line
          read(line(10:),*) path_length(i,j), energy(i,j), rel_energy(i,j)
        end do
        j = j + 1

      end if
    end do

    20 continue
    close(10)


  end subroutine



  subroutine read_dis_file(dist)

  use makedat

  implicit none

  character(*)          :: dist
  character(len(dist))  :: distN
  character(2)          :: num
  character(1000)       :: line
  integer :: i, j
  real(8) :: aa(100)

  integer :: ist, iend

    ist  = index(dist,"{")
    iend = index(dist,"}")

    if (iend /= ist + 1) then
      write(6,*)
      write(6,'("ERROR: dis file must be specified with {}")')
      stop
    end if

    write(num,'(i0)') 1
    distN = dist(1:ist-1)//trim(num)//dist(iend+1:)
    open(10,file=distN,status='old')
    read(10,'(a)') line
    close(10)

    aa = -1
    read(line,*,end=10) aa
    10 continue

    nelement = 1
    do while (aa(nelement) > 0) 
      nelement = nelement + 1
    end do
    nelement = nelement - 1

    allocate(dist_data(nelement, iter, nreplica))

    do i = 1, nreplica
      write(num,'(i0)') i
      distN = dist(1:ist-1)//trim(num)//dist(iend+1:)
      open(10,file=distN,status='old')

      j=0
      do while(.true.)
        j=j+1
        read(10,*,end=20) dist_data(:,j,i)
      end do

      20 continue
      close(10)

    end do

  end subroutine

  subroutine print_data()

  use makedat

  implicit none

  character(4)   :: num
  character(100) :: fout
  integer :: i, j, k, idx

    idx=0
    call print_to_file()

    if(allocated(dist_data)) then
      do idx = 1, iter-1, intvl
        call print_to_file_withdis()
      end do

      idx = iter
      call print_to_file_withdis()

    else
      do idx = 1, iter-1, intvl
        call print_to_file()
      end do

      idx = iter
      call print_to_file()

    end if

    contains

    subroutine print_to_file()

    write(num,'(i0)') idx
    fout=basename//trim(num)//'.dat'
    open(10,file=fout,status='unknown')
    do j = 1, nreplica
      write(10,'(i4,$)') j
      write(10,'(f12.4,$)') path_length(j,idx)
      write(10,'(f12.4,$)')  rel_energy(j,idx)
      write(10,*)
    end do
    close(10)

    end subroutine print_to_file

    subroutine print_to_file_withdis()

    write(num,'(i0)') idx
    fout=basename//trim(num)//'.dat'
    open(10,file=fout,status='unknown')
    do j = 1, nreplica
      write(10,'(i4,$)') j
      write(10,'(f12.4,$)') path_length(j,idx)
      write(10,'(f12.4,$)')  rel_energy(j,idx)
      do k = 2, nelement
        write(10,'(f12.3,$)')  dist_data(k, idx, j)
      end do
      write(10,*)
    end do
    close(10)

    end subroutine print_to_file_withdis

  end subroutine

