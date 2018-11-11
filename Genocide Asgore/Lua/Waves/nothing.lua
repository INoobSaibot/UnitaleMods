--Nothing


function Update()
    if(GetGlobal("EndWave") == true) then
        EndWave()
        SetGlobal("EndWave", false)
    end
end