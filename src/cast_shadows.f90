! The instructions and a demo of how Fortran code can be included
! in an R package is available in: https://github.com/coolbutuseless/simplefortran
! Source code distributed under GPL-2
! Copyright holder: Javier G. Corripio

SUBROUTINE doshade(dem, sunvector, cols, rows, dl, sombra)
IMPLICIT NONE
INTEGER :: cols, rows, newshape(2)
DOUBLE PRECISION :: z(cols,rows), sombra(cols, rows), dem(cols*rows),sunvector(3)
INTEGER :: idx, jdy, n, i, j, f_i, f_j, casx, casy
DOUBLE PRECISION :: inversesunvector(3), normalsunvector(3), vectortoorigin(3)
DOUBLE PRECISION :: dl, dx, dy, zprojection, zcompare
inversesunvector = -sunvector/Maxval(ABS(sunvector(1:2)))
normalsunvector(3)=sqrt(sunvector(1)**2+sunvector(2)**2)
normalsunvector(1)=-sunvector(1)*sunvector(3)/normalsunvector(3)
normalsunvector(2)=-sunvector(2)*sunvector(3)/normalsunvector(3)
newshape(1)=cols
newshape(2)=rows
z=reshape(dem,newshape)
!*** casx is an integer, this makes the value large enough to compare effectively
casx=NINT(1e6*sunvector(1))        
casy=NINT(1e6*sunvector(2))
SELECT CASE (casx)
!******** case (:0) means sunvector(x) negative, 
! sun is on the West: beginning of grid cols
CASE (:0)    
f_i=1            !** fixed i_value
CASE default
f_i=cols
END SELECT
SELECT CASE (casy)
!******** case (:0) sunvector(y) negative, 
! Sun is on the North: beginning of grid rows
CASE (:0)
f_j=1
CASE default 
f_j=rows
END SELECT
!******************* Grid scanning *******************************
!*** the array sombra stores the shaded cells, it is set 
!*** to 1 before the grid scanning.
!*****************************************************************
sombra = 1
j=f_j
DO i=1, cols        
    n = 0
    zcompare = -HUGE(zcompare) !** initial value lower than any possible zprojection
    DO 
        dx=inversesunvector(1)*n
        dy=inversesunvector(2)*n
        idx = NINT(i+dx)
        jdy = NINT(j+dy)
        IF ((idx < 1) .OR. (idx > cols) .OR. (jdy < 1) .OR. (jdy > rows)) exit
        vectortoorigin(1) = dx*dl
        vectortoorigin(2) = dy*dl
        VectortoOrigin(3) = z(idx,jdy)
        zprojection = Dot_PRODUCT(vectortoorigin,normalsunvector)
        IF (zprojection < zcompare) THEN 
            sombra(idx,jdy) = 0 
            ELSE
            zcompare = zprojection
        END IF  
        n=n+1
    END DO 
END DO
i=f_i
DO j=1,rows
    n = 0
    zcompare = -HUGE(zcompare)  !** initial value lower than any possible zprojection
    DO 
        dx=inversesunvector(1)*n    
        dy=inversesunvector(2)*n
        idx = NINT(i+dx)
        jdy = NINT(j+dy)
        IF ((idx < 1) .OR. (idx > cols) .OR. (jdy < 1) .OR. (jdy > rows)) exit
        vectortoorigin(1) = dx*dl
        vectortoorigin(2) = dy*dl
        VectortoOrigin(3) = z(idx,jdy)
        zprojection = Dot_PRODUCT(vectortoorigin,normalsunvector)
        IF (zprojection < zcompare) THEN 
            sombra(idx,jdy) = 0 
            ELSE
            zcompare = zprojection
        END IF  
        n=n+1
    END DO 
END DO
END SUBROUTINE doshade
  
