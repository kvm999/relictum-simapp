package main

import (
	"os"

	simapp "github.com/andrew528i/relictum-simapp"
	"github.com/andrew528i/relictum-simapp/relictumd/cmd"
	"github.com/cosmos/cosmos-sdk/server"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	BaseDenom     = "GTN"
	BaseDenomUnit = 8
)

func RegisterDenom() {
	if err := sdk.RegisterDenom(BaseDenom, sdk.NewDecWithPrec(1, BaseDenomUnit)); err != nil {
		panic(err)
	}
}

func main() {
	RegisterDenom()

	rootCmd := cmd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, "", simapp.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}
