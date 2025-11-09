{
  description = "Templates and devShells for courses at TUM";

  inputs = {
    gbs = { url = "./gbs"; };
    it-sec = { url = "./it-sec"; };
    fpv = { url = "./fpv"; };
    eist = { url = "./eist"; };
  };

  outputs = { self, ... } @ inputs :
  let
    courses = {
      gbs = inputs.gbs;
      it-sec = inputs.it-sec;
      fpv = inputs.fpv;
      eist = inputs.eist;
    };

    build_templates = builtins.mapAttrs (name: value: {
      path = ./${name};
      description = "${name} template";
      welcomeText = "Please allow direnv by typing 'direnv allow'";
    });
    templates = build_templates courses;

    # TODO seriously clean this up
    mapToShells = builtins.mapAttrs (name: value: value.devShells); 
    mapShellToName = (shellName: shells: builtins.mapAttrs (name: value: { ${shellName} = value.default;}) shells);
    mapShellsToNames = builtins.mapAttrs (name: value: mapShellToName name value);
    mappedShells = mapShellsToNames shells;
    dissolveLists = builtins.mapAttrs (name: value: (builtins.zipAttrsWith (name2: values2: builtins.head values2) value)); 

    shells = mapToShells courses;
    shellList = builtins.attrValues mappedShells;
    zippedShells = builtins.zipAttrsWith (name: values: values) shellList;

    devShells = dissolveLists zippedShells;
  in
    {
      inherit templates;
      inherit devShells;
    };
}
