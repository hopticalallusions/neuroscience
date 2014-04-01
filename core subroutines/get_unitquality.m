if(runAutoUnitQuality~='n')
%     auto_unit_quality_SNR             %SNR-based scoring (needs to be improved to avoid discarding some good units)  note this subroutine contains additional parameters.
      auto_unit_quality_amp             %assigns '3' to any units with < minspikesperunit or < autoVoltageCutoff=60, assigns '2' to all other units.
else
    manual_unit_quality           %manually assign quality index to each unit.  subroutines below this use select_doclusters to select only units of specified quality.
end