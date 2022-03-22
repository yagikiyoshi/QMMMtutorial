
   implicit none

   integer, parameter :: nimg=16, ndim=5

   integer :: i, j, k, img
   real(8) :: rr(9), mep_rr(ndim,nimg), slen(nimg), ss
   real(8) :: coeff(4,nimg-1,ndim)
   integer :: nw
   real(8) :: ds
   real(8), allocatable :: win_rr(:,:)
   character(180) :: line
   character(2)   :: nn
   character(20)  :: fname
   integer :: len, stat
   character(:), allocatable :: dat
   intrinsic :: command_argument_count, get_command_argument


   if (command_argument_count() == 0) then
     write(6,'("USAGE: make_window rpath_xxx.dat")')
     stop
   end if

   call get_command_argument(1, length = len, status = stat)
   if (stat == 0) then
     allocate (character(len) :: dat)
     call get_command_argument(i, dat, status = stat)
   end if
   
   ! read MEP data
   open(10,file=dat,status='old')
   do i = 1, nimg
     read(10,'(a)') line
     read(line(29:136),*) rr
     mep_rr(1:4,i) = rr(1:4)
     mep_rr(5,i) = rr(6)
   end do
   close(10)

   !do i = 1, nimg
   !  write(6,'(2f12.6)') mep_rr(1,i), mep_rr(3,i)
   !end do

   ! calc path length
   slen(1) = 0.0D+00
   do i = 2, nimg
     ss = 0.0D+00
     do j = 1, ndim
       ss = ss + (mep_rr(j,i) - mep_rr(j,i-1))**2
     end do
     ss = sqrt(ss)
     slen(i) = slen(i-1) + ss
   end do
   
   write(6,'("Reaction path")')
   write(6,'(i4,f12.4)') (i, slen(i), i=1,nimg)

   ! interpolation
   do i = 1, ndim
     call cubic_spline_coeff(nimg, slen, mep_rr(i,:), coeff(:,:,i))
   end do

   ! generate window
   ds = 0.1D+00

   nw = int(slen(nimg)/ds)
   ds = slen(nimg)/nw
   nw = nw + 1

   write(6,'("US windows")')
   write(6,'("  o Num of Windows = ",i6)') nw
   write(6,'("  o Interval       = ",f6.4)') ds

   allocate(win_rr(ndim,nw))
   do i = 1, nw
     ss = (i-1)*ds
     do j = 1, ndim
       call cubic_spline(nimg, slen, mep_rr(j,:), coeff(:,:,j), ss, win_rr(j,i))
     end do
   end do

   open(10,file="win_rr.dat",status="unknown")
   do i = 1, nw
     write(10,'(i4,9f8.4)') i, win_rr(:,i)
   end do
   close(10)

   end

  !======1=========2=========3=========4=========5=========6=========7=========8
  !
  !  Subroutine    cubic_spline
  !> @brief        natrual cubic spline function
  !! @authors      KY
  !! @param[in]    init    : initialize if true
  !! @param[in]    nn      : size of data
  !! @param[in]    xx(nn)  : x values
  !! @param[in]    yy(nn)  : y values
  !! @param[inout] coeff(4,nn-1) : coefficients of cubic functions
  !! @param[in]    xin     : x value 
  !! @param[out]   yout    : y value at xin
  !
  !======1=========2=========3=========4=========5=========6=========7=========8

  subroutine cubic_spline(nn, xx, yy, coeff, xin, yout)

    ! formal arguments
    integer, intent(in)    :: nn
    real(8), intent(in)    :: xx(0:nn-1)
    real(8), intent(in)    :: yy(0:nn-1)
    real(8), intent(inout) :: coeff(0:3,0:nn-2)
    real(8), intent(in)    :: xin
    real(8), intent(out)   :: yout

    ! local arguments
    integer :: i, idx
    real(8) :: dx, dxi

    idx = nn-2
    do i = 1, nn-1
      if(xin < xx(i)) then
        idx = i-1
        exit
      end if
    end do

    dx   = xin - xx(idx)
!    dxi  = 1.0_wp
!    yout = 0.0_wp
    dxi  = 1.0d+00
    yout = 0.0d+00
    do i = 0, 3
       yout = yout + coeff(i,idx)*dxi
       dxi  = dxi * dx
    end do

  end subroutine cubic_spline

  !======1=========2=========3=========4=========5=========6=========7=========8
  !
  !  Subroutine    cubic_spline_coeff
  !> @brief        calculate the coefficients of cubic functions
  !! @authors      KY
  !! @param[in]    nn      : size of data
  !! @param[in]    xx(nn)  : x values
  !! @param[in]    yy(nn)  : y values
  !! @param[out]   coeff(4,nn-1) : coefficients of cubic functions
  !
  !======1=========2=========3=========4=========5=========6=========7=========8

  subroutine cubic_spline_coeff(nn, xx, yy, coeff)

    ! formal arguments
    integer, intent(in) :: nn
    real(8), intent(in) :: xx(0:nn-1)
    real(8), intent(in) :: yy(0:nn-1)
    real(8), intent(out) :: coeff(0:3,0:nn-2)

    ! local arguments
    integer :: i
    real(8) :: hh(0:nn-2), gg(0:nn-2)
    real(8) :: vii(1:nn-2), aii(1:nn-2), aij(1:nn-3), aji(2:nn-2)
    real(8) :: uii(0:nn-1)

    do i = 0, nn-2
      hh(i) = xx(i+1) - xx(i)
      gg(i) = (yy(i+1) - yy(i))/hh(i)
    end do

    do i = 1, nn-2
!      vii(i) = 6.0_wp*(gg(i) - gg(i-1))
!      aii(i) = 2.0_wp*(hh(i-1) + hh(i))
      vii(i) = 6.0d+00*(gg(i) - gg(i-1))
      aii(i) = 2.0d+00*(hh(i-1) + hh(i))
    end do

    do i = 1, nn-3
      aij(i)   = hh(i)
      aji(i+1) = hh(i)
    end do

    ! forward
    do i = 1, nn-3
      aij(i) = aij(i) / aii(i)
      vii(i) = vii(i) / aii(i)
      aii(i+1) = aii(i+1) - aij(i)*aji(i+1)
      vii(i+1) = vii(i+1) - vii(i)*aji(i+1)
    end do
    vii(nn-2) = vii(nn-2)/aii(nn-2)

    ! backward
    uii(nn-2) = vii(nn-2)
    do i = nn-3, 1, -1
      uii(i) = vii(i+1) - aij(i)*uii(i+1)
    end do
!    uii(0)    = 0.0_wp
!    uii(nn-1) = 0.0_wp
    uii(0)    = 0.0d+00
    uii(nn-1) = 0.0d+00

    ! calc coefficients
    do i = 0, nn-2
      coeff(0,i) = yy(i)
      coeff(1,i) = (yy(i+1) - yy(i))/hh(i) &
!                 - hh(i)*(2.0_wp*uii(i) + uii(i+1))/6.0_wp
!      coeff(2,i) = uii(i)*0.5_wp
!      coeff(3,i) = (uii(i+1) - uii(i))/hh(i)/6.0_wp
                 - hh(i)*(2.0d+00*uii(i) + uii(i+1))/6.0d+00
      coeff(2,i) = uii(i)*0.5d+00
      coeff(3,i) = (uii(i+1) - uii(i))/hh(i)/6.0d+00
    end do

  end subroutine cubic_spline_coeff
